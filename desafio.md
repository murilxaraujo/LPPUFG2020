# Encurtador de URL 🌎

Este desafio é baseado na [API GooLNK](https://goolnk.com/docs) e propõe uma re-implementação das funcionalidades + novas funcionalidades.

## Escopo

Deverá ser desenvolvida uma API que encurte urls para o usuário e deverá seguir os seguintes requisitos:

1. A api deve guardar as informações do usuário que a criou.
2. A api deve permitir ao usuário se autenticar usando email + senha (A senha deve ser armazenada em hash com no mínimo SHA258).
3. Todas as URLs encurtadas devem registrar o usuário que a criou
4. O usuário deve poder listar todas as URLs que ele encurtou
5. O usuário deve poder desativar uma url encurtada, contanto que ele a tenha criado
6. O usuário será identificado por um [JWT](https://jwt.io/)
7. O JWT gerado a partir da autenticação será usado para autorização nas requests seguintes
8. Ao acessar uma URL encurtada sua API deve realizar um redirect para a url original.
9. Os parâmetros serão enviados pelo corpo em formato JSON, exceto para requisições do tipo GET, que não possuem corpo.
10. Os dados podem ser persistidos em um DB SQL ou NOSQL

## Objetivo

O objetivo deste desafio é mostrar a eficiência e velocidade de processamento da linguagem Swift em relação a Javascript, avaliando também o tamanho total do projeto, incluindo as dependências.
A avaliação em relação ao tamanho da api deve ser medida através do peso da imagem Docker
A velociadade de processamento deverá ser medida com o tempo entre o envio da requisição e a resposta da API, podendo ser medido usando clientes como Postman, Insomnia ou CURL.

## Endpoints

### /auth - ```POST```
parâmetros:

* email: ```String```
* password: ```String```

retorno: ```JWT```

Descrição: ``` Deve autenticar um usuário, caso ele já exista, ou criar uma nova conta caso o usuário não exista. A resposta deve ser um JWT que identificará o usuário nas requisições seguintes.```

### /create - ```POST```

headers: 

* Auth-Token: ```JWT```

parâmetros:

* URL: ```String```

retorno:

* < urlCurta >:```String``` - Caso o usuário exista
* erro ```403``` - caso usuário não exista

### /list - ```GET```

headers: 

* Auth-Token: ```JWT```

retorno: ```Lista todas as URLs encurtadas pelo usuário, caso o token seja válido, caso não seja válido retorna erro 403```

### /hide - ```PATCH```

headers: 

* Auth-Token: ```JWT```

parâmetros:

* URLID: ```String```

retorno: ```Caso o usuário seja válido e ele tenha criado a URL especificada ela deve ser oculta e retornar erro 404 em caso de uso```

### /< urlCurtaID > - ```GET```

retorno: ```Redireciona o usuário para a url inicial, caso ela exista e não esteja oculta```

