package rian.example.quarkusfunction;

import static org.hamcrest.CoreMatchers.containsString;

import java.util.HashMap;
import java.util.Map;

import org.junit.jupiter.api.Test;

import io.quarkus.test.junit.QuarkusTest;
import io.restassured.RestAssured;

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
		.get("/ReportPandemic?country=south-africa&month=12&year=2020")
		.then()
		.statusCode(200)
		.contentType("application/json").body(containsString(("2020-12")));
	}

}
