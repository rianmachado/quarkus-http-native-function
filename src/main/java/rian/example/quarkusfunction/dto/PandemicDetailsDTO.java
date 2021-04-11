package rian.example.quarkusfunction.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public class PandemicDetailsDTO {

	@JsonProperty("Lat")
	private String lat;

	@JsonProperty("Lon")
	private String lon;

	@JsonProperty("Cases")
	private Integer cases;

	@JsonProperty("Status")
	private String status;

	@JsonProperty("Date")
	private String date;

	public String getLat() {
		return lat;
	}

	public void setLat(String lat) {
		this.lat = lat;
	}

	public String getLon() {
		return lon;
	}

	public void setLon(String lon) {
		this.lon = lon;
	}

	public Integer getCases() {
		return cases;
	}

	public void setCases(Integer cases) {
		this.cases = cases;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

}
