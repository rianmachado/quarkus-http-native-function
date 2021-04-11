package rian.example.quarkusfunction.dto;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PandemicResponseDTO {
	private String reportTitle;
	
	@JsonInclude(Include.NON_NULL)
	private List<PandemicDetailsDTO> reportDetails;
}
