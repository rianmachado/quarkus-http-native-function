package rian.example.quarkusfunction;

import static org.hamcrest.CoreMatchers.containsString;

import org.junit.jupiter.api.Test;

import io.quarkus.test.junit.QuarkusTest;
import io.restassured.RestAssured;

@QuarkusTest
public class CovidFunctionTest {

	@Test
	public void covidFunctionTest() {
		String myJson = "{\"country\":\"south-africa\",\"month\": 12,\"year\":2020}";
		RestAssured
		.given()
		.body(myJson)
		.when()
		.post("/covidFunction")
		.then()
		.statusCode(200)
		.contentType("application/json").body(containsString(("2020-12")));
	}

}
