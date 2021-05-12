package rian.example.quarkusfunction;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.inject.Inject;

import org.eclipse.microprofile.config.inject.ConfigProperty;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import io.quarkus.funqy.Funq;
import io.smallrye.mutiny.Uni;
import io.vertx.core.VertxOptions;
import io.vertx.ext.web.client.WebClientOptions;
import io.vertx.mutiny.core.Vertx;
import io.vertx.mutiny.ext.web.client.WebClient;
import rian.example.quarkusfunction.dto.PandemicDetailsDTO;
import rian.example.quarkusfunction.dto.PandemicResponseDTO;

public class PandemicFunction {

	private static final Logger LOGGER = LoggerFactory.getLogger(PandemicFunction.class);

	private WebClient client;

	@Inject
	Vertx vertx;

	@Inject
	FunctionHelper helper;

	@ConfigProperty(name = "covid.api.url")
	String url;

	@ConfigProperty(name = "covid.api.resource")
	String resource;

	@PostConstruct
	void initialize() {
		VertxOptions options = new VertxOptions();
		options.setBlockedThreadCheckInterval(32000);
		Vertx.vertx(options);
		client = WebClient.create(vertx,
				new WebClientOptions().setDefaultHost(url).setDefaultPort(443).setSsl(true).setTrustAll(true));
	}

	@Funq("ReportPandemic")
	public Uni<PandemicResponseDTO> reportPandemicDemo(Map<String, String> request) {

		List<PandemicDetailsDTO> list = new ArrayList<>();

		try {
			Uni<String> cases = client.get(String.format(resource, request.get("country"))).send().onItem()
					.transform(resp -> {
						if (resp.statusCode() == 200) {
							return resp.bodyAsString();
						} else {
							return String.valueOf(resp.statusCode());
						}
					});
			String data = cases.subscribe().asCompletionStage().get();
			if (!data.matches("^[0-9][0-9][0-9]$")) {
				list = helper.mapperToPandemicDetails(data);
			}

			return Uni.createFrom()
					.item(PandemicResponseDTO.builder().reportTitle("Evolution of cases in " + request.get("country"))
							.reportDetails(helper.buildPandemicData(list, request)).build());
		} catch (Exception e) {
			LOGGER.error(e.getLocalizedMessage(), e);
			return Uni.createFrom().item(PandemicResponseDTO.builder().reportTitle("Internal Function Error").build());
		}

	}

}
