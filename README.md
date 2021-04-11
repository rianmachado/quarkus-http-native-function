


# QUARKUS NATIVE - FUNQY
O Quarkus Funqy faz parte da estratégia sem servidor da Quarkus e visa fornecer uma API Java portátil para escrever funções implantáveis ​​em vários ambientes FaaS, como AWS Lambda, Azure Functions, Knative e Knative Events (Cloud Events). Também pode ser usado como um serviço autônomo.

Como Funqy é uma abstração que abrange vários provedores de nuvem/funções e protocolos diferentes, ela deve ser uma API muito simples e, portanto, pode não ter todos os recursos com os quais você está acostumado em outras abstrações remotas. Um bom efeito colateral, porém, é que o Funqy é o mais otimizado e o mais pequeno possível. Isso significa que, como Funqy sacrifica um pouco a flexibilidade, você obterá uma estrutura que tem pouca ou nenhuma sobrecarga.

# Devo usar o Funqy?
REST sobre HTTP se tornou uma maneira muito comum de escrever serviços na última década. Embora Funqy tenha uma ligação HTTP, não é uma substituição para REST. Como o Funqy precisa trabalhar em uma variedade de protocolos e plataformas de nuvem de funções, ele é muito minimalista e restrito. Por exemplo, se você usar o Funqy, perderá a capacidade de vincular (pense em URIs) aos dados que suas funções geram. Você também perde a capacidade de aproveitar recursos interessantes de HTTP, comocache-controle GETs condicionais. Muitos desenvolvedores concordarão com isso, pois muitos não usarão esses recursos ou estilos REST / HTTP. Você terá que tomar uma decisão sobre em que campo você está. O Quarkus oferece suporte à integração REST (por meio de JAX-RS, Spring MVC, Vert.x Web e Servlet) com vários provedores de nuvem / funções, mas existem algumas desvantagens de usando essa abordagem também. Por exemplo, se você deseja fazer HTTP com AWS Lambda , isso requer o uso do AWS API Gateway, que pode retardar a implantação e o tempo de inicialização a frio ou até mesmo custar mais.

O objetivo do Funqy é permitir que você escreva funções entre provedores de forma que você possa sair do seu provedor de funções atual se, por exemplo, eles começarem a cobrar muito mais por seus serviços. Outro motivo pelo qual você pode não querer usar o Funqy é se você precisa acessar APIs específicas do ambiente da função de destino. Por exemplo, os desenvolvedores geralmente desejam acessar o Contexto da AWS no Lambda. Nesse caso, dizemos que é melhor usar a integração do Quarkus Amazon Lambda .

## Pré requisitos
* Java 11
* Lombok
* Conta na Azure
* Conta na AWS
* Docker (Para gerar executável nativo)

# Mostre um exemplo
```java
  @Funq("ReportPandemic")
	public Uni<ResponseDTO> reportPandemic(RequestDTO request) {
		return Uni.createFrom().item(
				ResponseDTO.builder().otherInfo(request.getOtherInfo()).guid(UUID.randomUUID().toString()).build());
   }
```
Funqy suporta o tipo reativo Smallrye Mutiny Uni como um tipo de retorno. O único requisito é que o Unideve preencher o tipo genérico.

## Start da aplicação(Modo desenvolvimento)
Na raiz do projeto execute: `mvn compile quarkus:dev`

## Gerando executável nativo
Você não precisa descar o __java__ para ter um tempo de inicialização rápido. O Quarkus vai te ajudar, para maiores informações acesse: [QUARKUS - BUILDING A NATIVE EXECUTABLE](https://quarkus.io/guides/building-native-image#container-runtime)

Muitas vezes, basta criar um executável Linux nativo para seu aplicativo Quarkus (por exemplo, para rodar em um ambiente em contêiner) e gostaria de evitar o problema de instalar a versão GraalVM adequada para realizar esta tarefa (por exemplo, em ambientes de CI, é uma prática comum instalar o mínimo de software possível).

Para isso, o Quarkus oferece uma maneira muito conveniente de criar um executável Linux nativo, aproveitando um tempo de execução de contêiner, como Docker ou podman. A maneira mais fácil de realizar essa tarefa é executar:

`mvn clean package -Pnative -Dquarkus.native.container-build=true -Dquarkus.native.native-image-xmx=3G`

## E agora?

* __Visão Azure:__
Você encontrará na pasta __azure-config__ uma estrutura pronta para trabalhar com Custom Handler, forma de trabalhar com aplicativos executáveis na Azure. Para maiotes informações acesse: [Azure Function](https://docs.microsoft.com/en-us/azure/azure-functions/create-first-function-vs-code-other?tabs=go%2Cmacos) A documentação da Microsoft irá mostrar como trabalar com executávies __GO__ mas não esqueça que ja temos um executável nativo entreguie pelo __Quarkus__

* __Visão AWS:__
