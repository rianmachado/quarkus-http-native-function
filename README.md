# Programação Reativa Com Quarkus
A programação reativa é um modelo de desenvolvimento estruturado em torno de fluxos de dados assíncronos.

Usando a forma tradicional de desenvolvimento para preparar uma boa cerveja podemos considerar a chamada para o método prepararAgua(temperatura) e 
prepararMalte(), assim que tivermos isso pronto acionamos o método moer(malte) na sequência executamos o
metodo misturarTudo() e por fim adicionarLupulo(). Perfeito, a cerveja estará deliciosa.

Mas, imagine se não tivermos malte? Bom, o sistema falhará assim que o método moer(malte) for invocado.
Na programação reativa as coisas acontecem de forma bem diferente. Os eventos ocorrem de forma paralela sem precisar seguir nenhuma ordem cronológica e linear. O sistema não irá travar pois através de bibliotecas específicas será possível continuar o preparo da cerveja sem a etapa que irá moer o malte, isso porque as outras etapas de preparo serão executadas e quando o malte tiver preparado o método moer(malte) será executado.

As execuções são manipuladas a partir de eventos que notificam os interessados que estão a espera de mensagens para que cada um possa realizar seu trabalho.

# Um pouco mais
Ao usar a programação reativa, os fluxos de dados serão a espinha dorsal do seu aplicativo. Eventos, mensagens, chamadas e até mesmo falhas serão transmitidas por um fluxo de dados, possibilitando observar esses fluxos e reagir quando um valor é emitido. Pode-se dizer que a programação reativa é uma versão extendida e mais poderosa do padrão [Observer](https://pt.wikipedia.org/wiki/Observer)

Os frameworks reativos oferecem uma espetacular caixa de ferramentas para manipulação de stream; podemos filtrá-los, transformá-los, combiná-los entre outras dezenas de operações. 

# Alguns cenários

* __Abstração sobre processamento assícrono:__ Frameworks reativos fornecem uma função simples para processamento assíncrono, desafogando sua aplicação dos detalhes mais complexos envolvendo MULTITHREADING e permitindo que seu código possa concentra-se na lógica de manipulação de eventos. 

* __Chamada para serviços externos(REST, RPC,etc)__ Operações realizadas sobre HTTP são bloqueantes por natureza; Ao fornecer uma simplificação para código assíncrono a programação reativa pode ajudá-lo a desbloquear o código de cliente HTTP. Mas isso é a parte mais simples. Em arquitetura de microserviço é comum um código de back-and construir uma composição entre várias chamadas e Frameworks reativos podem ajudar a orquestrar chamadas com a vantagem de NÃO bloquear o código no cliente.

# Quarkus
Quarkus é reativo. Nele encontraremos um motor reativo chamado de Vert.x. Todas as entradas e saídas de rede passam pelo Vertx de forma não
bloqueante. Imagine uma solicitação HTTP de entrada. O servidor HTTP(Vert.x) embutido no Quarkus recebe a solicitação e a encaminha para o aplicativo.
Se a solicitação for direcionada a um método imperative (JAX-RS tradicional), a camada de roteamento invoca o método de recurso em uma __thread de
trabalho e grava a resposta quando os dados estiverem disponíveis. Até agora, nada de novo ou excepcional__.

Mas, se a solicitação HTTP tem como alvo um método reativo (JAX-RS usando RESTEasy Reactive), a camada de roteamento invoca a thread de entrada e
saída oferecendo muitos beneficios como maior concorrência e desempenho. As threads de entrada e saída(I/O) são usadas para lidar com varias solicitações simutânias. Assim que o tratamento de Uma solicitação não pode progredir porque precisa executar algum I/O o Quarkus agenda esse I/O continuando assim com a solicitação, quando o I/O agendado é concluido, segue o encadeamento de entrada e saída. Diante disso muitos componentes são projetados com reativos em mente, como acesso ao banco de dados (PostgresQl: MySQliM
saída oferecendo muitos beneficios como maior concorrência e desempenho. As threads de entrada e saída(I/O) são usadas para lidar com varias solicitações simutânias. Assim que o tratamento de Uma solicitação não pode progredir porque precisa executar algum I/O o Quarkus agenda esse I/O continuando assim com a solicitação, quando o I/O agendado é concluido, segue o encadeamento de entrada e saída. Diante disso muitos componentes do Quarkus são projetados com características reativas como por exemplo: acesso a banco de dados(Postgres, MySQL,Mongo, etc), serviços de aplicativo(e-mail,template engine,etc), mensagens(Kafka, AMQP,etc) e assim por diante. Mas para ser beneficiado totalmente desse modelo, __o código do aplicativo deve ser escrito de maneira não bloqueante.__ É ai que ter uma API reativa torna-se uma arma definitiva.

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

