# QUARKUS NATIVE - FUNQY
O Quarkus Funqy faz parte da estratégia sem servidor da Quarkus e visa fornecer uma API Java portátil para escrever funções implantáveis ​​em vários ambientes FaaS, como AWS Lambda, Azure Functions, Knative e Knative Events (Cloud Events). Também pode ser usado como um serviço autônomo.

Como Funqy é uma abstração que abrange vários provedores de nuvem / funções e protocolos diferentes, ela deve ser uma API muito simples e, portanto, pode não ter todos os recursos com os quais você está acostumado em outras abstrações remotas. Um bom efeito colateral, porém, é que o Funqy é o mais otimizado e o mais pequeno possível. Isso significa que, como Funqy sacrifica um pouco a flexibilidade, você obterá uma estrutura que tem pouca ou nenhuma sobrecarga.

# Um pouco mais


# Importante
É imprescindível termos em mente que iremos manipular o Vert.x a partir do [Mutiny](https://smallrye.io/smallrye-mutiny/),biblioteca de programação reativa que permite expressar e compor ações assíncronas de duas formas: 

* io.smallrye.mutiny.Uni - for asynchronous action providing 0 or 1 result
* io.smallrye.mutiny.Multi - for multi-item (with back-pressure) streams

```java
  @GET
  @Path("{id}")
  public Uni<Response> get(@PathParam("id") final Long id) {
	return service.findById(id).map(data -> {
		if (data.getId() == null) {
				return null;
			}
			return ok(data).build();
		}).onItem().ifNull().continueWith(status(Status.NOT_FOUND).build());
	}
  @GET
  public Multi<PearsonResponseModel> get(){
    	return service.findAll();
  }
```

## Pré requisitos
* Java 11 and later
* Lombok
* Docker (Para execução do Postgres)

## Start da aplicação
Após iniciar o containner Postgres(veja commando-docker.txt) execute: `mvn compile quarkus:dev`

