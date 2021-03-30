package rian.example.quarkusfunction.dto;

import java.util.List;

public class CountryDTO {

	private String name;
	private List<CountryDetailsDTO> countryDetails;
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public List<CountryDetailsDTO> getCountryDetails() {
		return countryDetails;
	}
	public void setCountryDetails(List<CountryDetailsDTO> countryDetails) {
		this.countryDetails = countryDetails;
	}
	
	

}
