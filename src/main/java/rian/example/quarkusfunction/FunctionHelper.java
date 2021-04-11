package rian.example.quarkusfunction;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.enterprise.context.Dependent;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import rian.example.quarkusfunction.dto.PandemicDetailsDTO;

@Dependent
public class FunctionHelper {

	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss'Z'");

	public List<PandemicDetailsDTO> mapperToPandemicDetails(String data)
			throws JsonMappingException, JsonProcessingException {
		List<PandemicDetailsDTO> list = new ArrayList<>();
		ObjectMapper mapper = new ObjectMapper();
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
		list = mapper.readValue(data, new TypeReference<List<PandemicDetailsDTO>>() {
		});
		return list;
	}

	public List<PandemicDetailsDTO> buildPandemicData(List<PandemicDetailsDTO> data, Map<String, String> filter) {

		List<PandemicDetailsDTO> result = new ArrayList<>();
		LocalDate initial = LocalDate.of(Integer.parseInt(filter.get("year")), Integer.parseInt(filter.get("month")),
				1);
		LocalDate start = initial.with(TemporalAdjusters.firstDayOfMonth());
		LocalDate end = initial.with(TemporalAdjusters.lastDayOfMonth());

		result = data.stream().filter(filterData -> LocalDate.parse(filterData.getDate(), formatter).isAfter(start)
				&& LocalDate.parse(filterData.getDate(), formatter).isBefore(end)).collect(Collectors.toList());

		return result;

	}

}
