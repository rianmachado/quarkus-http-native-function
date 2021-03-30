package rian.example.quarkusfunction;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.stream.Collectors;

import javax.annotation.PostConstruct;
import javax.inject.Inject;

import org.eclipse.microprofile.config.inject.ConfigProperty;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;

import io.quarkus.funqy.Funq;
import io.smallrye.mutiny.Uni;
import io.vertx.core.VertxOptions;
import io.vertx.ext.web.client.WebClientOptions;
import io.vertx.mutiny.core.Vertx;
import io.vertx.mutiny.ext.web.client.WebClient;
import rian.example.quarkusfunction.dto.CountryDetailsDTO;
import rian.example.quarkusfunction.dto.RequestDTO;
import rian.example.quarkusfunction.dto.ResponseDTO;

public class CovidFunction {

	private static final Logger LOGGER = LoggerFactory.getLogger(CovidFunction.class);

	private WebClient client;

	@Inject	Vertx vertx;

	@ConfigProperty(name = "covid.api.url")
	String url;

	@ConfigProperty(name = "covid.api.resource")
	String resource;

	@Funq
	public Uni<ResponseDTO> covidFunction(RequestDTO request) throws InterruptedException, ExecutionException {

		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss'Z'");

		String retorno = getCases(request.getCountry()).subscribe().asCompletionStage().get();

		List<CountryDetailsDTO> list = mapperCountryDetailsToList(retorno);

		LocalDate initial = LocalDate.of(request.getYear(), request.getMonth(), 1);
		LocalDate start = initial.with(TemporalAdjusters.firstDayOfMonth());
		LocalDate end = initial.with(TemporalAdjusters.lastDayOfMonth());

		List<CountryDetailsDTO> result = list.stream()
				.filter(filter -> LocalDate.parse(filter.getDate(), formatter).isAfter(start)
						&& LocalDate.parse(filter.getDate(), formatter).isBefore(end))
				.collect(Collectors.toList());

		return Uni.createFrom().item(ResponseDTO.builder().reportTitle("Evolution of cases in " + request.getCountry())
				.reportDatails(result).build());
	}

	@PostConstruct
	void initialize() {
		VertxOptions options = new VertxOptions();
		options.setBlockedThreadCheckInterval(32000);
		Vertx.vertx(options);
		client = WebClient.create(vertx,
				new WebClientOptions().setDefaultHost(url).setDefaultPort(443).setSsl(true).setTrustAll(true));
	}

	private Uni<String> getCases(String input) {
		return client.get(String.format(resource, input)).send().map(resp -> {
			return resp.bodyAsString();
		});
	}

	private List<CountryDetailsDTO> mapperCountryDetailsToList(String response) {
		List<CountryDetailsDTO> list = new ArrayList<>();
		try {
			ObjectMapper mapper = new ObjectMapper();
			mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
			list = mapper.readValue(response, new TypeReference<List<CountryDetailsDTO>>() {
			});
		} catch (Exception e) {
			LOGGER.error(e.getLocalizedMessage(), e);
		}
		return list;
	}

}
