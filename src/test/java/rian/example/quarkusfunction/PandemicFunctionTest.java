package rian.example.quarkusfunction;

import static org.hamcrest.CoreMatchers.containsString;

import java.util.HashMap;
import java.util.Map;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import io.quarkus.test.junit.QuarkusTest;
import io.restassured.RestAssured;
import io.restassured.response.Response;

@QuarkusTest
public class PandemicFunctionTest {

	@Test
	public void reportPandemicGetTest() {
		Map<String,String> args = new HashMap<>();
		args.put("coutry","south-africa");
		args.put("month","12");
		args.put("yaer","2020");
		RestAssured
		.given()
		.get("/ReportPandemicDemo?country=south-africa&month=12&year=2020")
		.then()
		.statusCode(200)
		.contentType("application/json").body(containsString(("2020-12")));
	}
	
	@Test
	public void reportPandemicPostTest() {
		String body = "{\"otherInfo\":\"south-africa\"}";
		Response response = RestAssured
		.given()
		.body(body)
		.post("ReportPandemic");
		Assertions.assertNotNull(response.path("guid"));
	}

}
