library(tidyverse)
library(readr)
library(data.table)


# Empinhando as bases -----------------------------------------------------

## Neste scrip eu importo as bases do Censo Escolar que serão úteis em minhas 
## pesquisas futuras

## As varáveis dos anos 2013 a 2014 possuem nomes diferentes, por isso a decisão
## importar separadamente. 

## Nesta etapa, eu seleciono as variáveis equivantes nas duas base de dados
variaveis_selecionadas_1314 <- c("ANO_CENSO",
                            "NUM_IDADE_REFERENCIA",
                            "ID_DEPENDENCIA_ADM_ESC",
                            "FK_COD_ETAPA_ENSINO",
                            "FK_COD_ESTADO_ESCOLA",
                            "COD_MUNICIPIO_ESCOLA")


variaveis_selecionadas_1520 <- c("NU_ANO_CENSO",
                                 "NU_IDADE_REFERENCIA",
                                 "TP_DEPENDENCIA",
                                 "TP_ETAPA_ENSINO",
                                 "CO_UF",
                                 "CO_MUNICIPIO")

## Nesta etapa, eu aponto os caminhos das bases de dados
arq_matriculas_no_1314 <-list.files("data/2013_2014/",
                                    full.names = T)

arq_matriculas_no_1520 <-list.files("data/2015_2020/", 
                                    full.names = T)
## Aqui, eu importo as Matrículas dos alunos do Norte do Brasil
## Eu opto pelo pacote função "fread" do pacote data.table, pela possibilidade
## de importar apenas as variáveies de interesse.
matriculas_no_1314 <- map_dfr(arq_matriculas_no_1314, 
                              fread,
                              select = (variaveis_selecionadas_1314))

matriculas_no_1520 <- map_dfr(arq_matriculas_no_1520, 
                              fread, 
                              select = (variaveis_selecionadas_1520))

## Como as bases tem nomes diferentes nas tabelas, eu preferi usar a função colnames
## ao invés do mutate (que ainda não tenho muita experiência)
colnames(matriculas_no_1314) <- names(matriculas_no_1520) 

matriculas_no_1320 <- bind_rows(matriculas_no_1314, matriculas_no_1520)

# write_rds(matriculas_no_1320, file = "data/MATRICULA_NORTE.rds")

## Para não ter que repassar toda a base de dados, aqui gero uma amostra que será
## utilizada em minha análise
amostra_dados <- slice_sample(matriculas_no_1320, n=10000)

write_rds(amostra_dados, file = "data/amostra_dados.rds")
