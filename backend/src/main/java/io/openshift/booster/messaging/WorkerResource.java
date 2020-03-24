package io.openshift.booster.messaging;

import java.util.UUID;

import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.eclipse.microprofile.config.inject.ConfigProperty;

@Path("/api")
public class WorkerResource {

    private static final String ID = "worker-quarkus-" + UUID.randomUUID()
                                        .toString().substring(0, 4);

    @ConfigProperty(name = "worker.cloud.id", defaultValue = "unknown")
    String cloudId;

    @POST
    @Path("/process")
    @Produces(MediaType.APPLICATION_JSON)
    public Response process(Message message) {
        Response response = new Response(message.getRequestId(), ID, cloudId, process(message.getRequest()));
        return response;
    }

    private String process(Request request) {
    
        String text = request.getText();

        if (request.isUppercase()) {
            text = text.toUpperCase();
        }
    
        if (request.isReverse()) {
            text = new StringBuilder(text).reverse().toString();
        }
        return "Aloha " + text;
    }
}