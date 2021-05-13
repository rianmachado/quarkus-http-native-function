


# QUARKUS NATIVE - FUNQY
Funqy faz parte da estratégia sem servidor oferecida pelo Quarkus que visa fornecer uma API Java portátil para escrever funções implantáveis ​​em vários ambientes FaaS, como AWS Lambda, Azure Functions, Knative e Knative Events (Cloud Events). Também pode ser usado como um serviço autônomo.


# Devo usar o Funqy?
REST sobre HTTP se tornou uma maneira muito comum de escrever serviços na última década. É importante destacar que o Funqy HTTP não é uma substituição para REST sobre HTTP. Como o Funqy precisa trabalhar com uma variedade de protocolos e provedores de funções, ele é muito minimalista e restrito. Por exemplo, se você usar o Funqy, perderá recursos REST com controle de cache. O Quarkus oferece suporte à integração REST por meio de JAX-RS, Spring MVC, Vert.x Web e Servlet.

O objetivo do Funqy é permitir que você escreva funções entre provedores de forma que possa sair do seu provedor de funções atual para outro que ofereça valores mais atrativos. Outro motivo pelo qual você vai querer usar o Funqy é se você precisa acessar APIs específicas do ambiente da função de destino. Por exemplo, eventos específicos do AWS no Lambda. Nesse caso é melhor usar a integração do Quarkus Amazon Lambda.

## Pré requisitos
* Java 11
* Lombok
* Conta na Azure
* Conta na AWS
* Az CLI
* AWS CLI
* Docker (Para gerar executável nativo)

# Funqy suporta o tipo reativo Smallrye Mutiny e Uni.
```java
  @Funq("ReportPandemic")
	public Uni<ResponseDTO> reportPandemic(RequestDTO request) {
		return Uni.createFrom().item(
				ResponseDTO.builder().otherInfo(request.getOtherInfo()).guid(UUID.randomUUID().toString()).build());
   }
```


## Start da aplicação(Modo desenvolvimento)
Na raiz do projeto execute: `mvn compile quarkus:dev`

## Gerando executável nativo
Você não precisa descar o __java__ para ter um tempo de inicialização rápido. Para maiores informações acesse: [QUARKUS - BUILDING A NATIVE EXECUTABLE](https://quarkus.io/guides/building-native-image#container-runtime)


Muitas vezes, basta criar um executável Linux nativo para seu aplicativo Quarkus (por exemplo, para rodar em um ambiente em contêiner). Esses executáveis são criados a partir da GraalVM e caso queira abstrair a instalação e configuração dessa VM, o que vai simplificar ambientes de CI por exemplo, o Quarkus oferece uma maneira muito conveniente de criar um executável Linux nativo, aproveitando um tempo de execução de contêiner, como Docker ou podman. A maneira mais fácil de realizar essa tarefa é executar:

`mvn clean package -Pnative -Dquarkus.native.container-build=true -Dquarkus.native.native-image-xmx=3G`
Após execução do comando com sucesso, teremos um executável no diretório __azure-config__

## E agora?

* __Visão Azure:__
Você encontrará na pasta __azure-config__ uma estrutura pré definida com Custom Handler, que é a forma de trabalhar com aplicativos executáveis na Azure. Para maiores informações acesse: [Azure Function](https://docs.microsoft.com/en-us/azure/azure-functions/create-first-function-vs-code-other?tabs=go%2Cmacos) 
A documentação da Microsoft irá mostrar um exemplo em __GO__ mas não esqueça que ja temos um executável do nosso exemplo entregue pelo __Quarkus__. 
Aconselho você conhecer os planos da Microsoft como por exemplo, __consumption e premium__. Isso vai te ajudar a escolher estratégias referente a cold start. Nosso exemplo oferece alguns scripts Azure para facilitar a vida.

Antes de proceguir realize login na sua conta Azure, utilizando o comando `az login` depois execute
 `azure-config/scripts/consumption/create_all_resources.sh <seu resource group> <seu storage account> ReportPandemic brazilsouth`. Certifique que está na raiz do projeto.
 
__Os Scripts tiveram a colaboração do Daniel Garcia Lamas(https://github.com/danielamas)__  

* __Visão AWS:__
Através da dependência `quarkus-funqy-amazon-lambda` o __Quarkus__ vai entrgar scripts na pasta __target__ para que possa realizar o deploy do executável na AWS. Para maiores informações acesse: Deploy to AWS Lambda Custom (native) Runtime(https://quarkus.io/guides/amazon-lambda)
Antes de proceguir realize login na sua conta AWS, acesse o diretório __target__ e execute `sh target/manage.sh native create`



