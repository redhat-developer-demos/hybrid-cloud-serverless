package io.openshift.booster.messaging;

import io.quarkus.test.junit.QuarkusTest;
import org.junit.jupiter.api.Test;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.containsString;

@QuarkusTest
public class ExampleResourceTest {

    @Test
    public void testWorkerEndpoint() {
        given()
          .body("{\"requestId\" : 1337,\"request\" :{\"text\":\"foo\",\"uppercase\" : false,\"reverse\" : false }}")
          .contentType("application/json")
          .when().post("/api/process")
          .then()
             .statusCode(200)
             .body(containsString("Aloha foo"));
    }

}