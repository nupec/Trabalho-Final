# Pacotes
# library(lubridate)
# library(plyr)

# Tratamento dos dados ----------------------------------------------------

## Nesta seção é feita a importação do arquivo que possui a projeção da população
## brasileira entre os anos de 2010 e 2060

df_projecoes = readxl::read_excel("data-raw/popIDADES.xls", skip = 195, n_max = 92)
idades <- df_projecoes[1] |> as.vector() # Esta variável será reutilizada posteriormente

## Calculando indices das idades

indices <- df_projecoes |> dplyr::select(where(is.numeric)) |>
  dplyr::summarise(
    across(
      .cols = everything(),
      .fns = prop.table
    ))

## IMPORTANTE: Estes índcices serão utilIzados para estimar a população, por idade, de cada município

## O próximo passo é importar a popuçação dos municípios brasileiros
populacao_municipios <- readxl::read_excel("data-raw/popESTIMADA.xlsx")

## As cidade selecionadas são: São eles: Itacoatiara, Itapiranga, Silves, São Sebastião,
## Nova Olinda do Norte, Urucará e Urucurituba
cod_cidades_selecionadas <- c(1301902, 1302009, 1303106,
                              1304005, 1303957, 1304302, 1304401)

## Filtrando as cidade de interesse
cidades_selecionadas <- populacao_municipios |>
  dplyr::filter(Cod %in% cod_cidades_selecionadas) |>
  dplyr::select("Cod", "Municipio", "2014":"2020")

# Função que seleciona a população de uma cidade, em um ano específico
pop_cidade_ano <- function(df1, cidade1, ano1, col2="Municipio") {
    dplyr::filter(df1, Municipio == {{cidade1}}) |>
    dplyr::select({{col2}}, {{ano1}})
}

## Aplicando a função para uma cidade específica
pop_cidade_ano(cidades_selecionadas, "Silves", all_of("2016"))

# Estimativa das idades da população de uma cidade -------------------------------------
  # Nome da cidade:
  cidade2 = "Silves"
  # Ano:
  ano2    = "2015"
  pop_cidade = pop_cidade_ano(cidades_selecionadas, cidade2, all_of(ano2) )

  # Estimativa das idade da cidade e ano definidos anteriormente
  estimativa_cidade_idade <- ceiling(as.numeric(pop_cidade[2])*indices[ano2]) |>
    dplyr::mutate(
    idade        = c(0:90),
    cidade       = cidade2)

   estimativas_por_idade <- estimativa_cidade_idade |>
    dplyr::mutate(
      Faixa_Etaria = dplyr::case_when(
        idade %in% 0:3 ~ "0 a 3 anos",
        idade %in% 4:5 ~ "4 a 5 anos",
        idade %in% 6:14 ~ "6 a 14 anos",
        idade %in% 15:17 ~ "15 a 17 anos",
        idade >17 ~ "mais de 18 anos"))

  estimativas_por_idade <- estimativas_por_idade |>
        dplyr::mutate(Faixa_Etaria = factor(
        Faixa_Etaria,
        levels = c("0 a 3 anos",
                   "4 a 5 anos",
                   "6 a 14 anos",
                   "15 a 17 anos",
                   "mais de 18 anos"),
        ordered = TRUE
      ))|>
      dplyr::arrange(Faixa_Etaria)


  tabelaFH <- estimativas_por_idade |>
    dplyr::group_by(Faixa_Etaria) |>
    dplyr::summarise(
      "Pop 2015" = sum(`2015`)
    ) |>
    janitor::adorn_totals() |>
    knitr::kable(col.names = c("Faixa-Etaria", "População"))

  # Importante: a escolha de "forçar" o arredondamento para cima é deliberada.
  # A ideia é não subestimar a população que deve ser antendida.

## Empinhando as bases do Censo Escolar -----------------------------------------------------

  ## Neste scrip, importa-se as bases do Censo Escolar que serão úteis em minhas
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
  arq_matriculas_no_1314 <-list.files("data-raw/2013_2014/",
                                      full.names = T)

  arq_matriculas_no_1520 <-list.files("../../data/matricula_no/2015_2020/",
                                      full.names = T)
  ## Aqui, eu importo as Matrículas dos alunos do Norte do Brasil
  ## Eu opto pelo pacote função "fread" do pacote data.table, pela possibilidade
  ## de importar apenas as variáveies de interesse.

  matriculas_no_1314 <- purrr::map_dfr(arq_matriculas_no_1314,
                                       fread,
                                       select = (variaveis_selecionadas_1314))


  matriculas_no_1520 <- purrr::map_dfr(arq_matriculas_no_1520,
                                fread,
                                select = (variaveis_selecionadas_1520))

    ## Como as bases tem nomes diferentes nas tabelas, eu preferi usar a função colnames
  ## ao invés do mutate (que ainda não tenho muita experiência)
  colnames(matriculas_no_1314) <- names(matriculas_no_1520)

  matriculas_no_1320 <- dplyr::bind_rows(matriculas_no_1314, matriculas_no_1520)

  readr::write_rds(matriculas_no_1320, file = "data/matricula1320.rds")

  ## Para não ter que repassar toda a base de dados, aqui gero uma amostra que será
  ## utilizada em minha análise
  #amostra_dados <- slice_sample(matriculas_no_1320, n=10000)

  # write_rds(amostra_dados, file = "data/amostra_dados.rds")

# Calculando as Metas -----------------------------------------------------

# Importando a amostra da matricula

  matriculas_no_1320 <- readr::read_rds("data/amostra_dados.rds")

#  Populacao de 0 a 3 anos

    qtde0a3 <- estimativas_por_idade |>
    dplyr::filter(Faixa_Etaria=="0 a 3 anos") |>
#    dplyr::group_by(Faixa_Etaria) |>
    dplyr::summarise(
      Populacao = sum(`2015`)
    ) |> as.numeric()

# Matricula de 0 a 3 anos

  matricula0a3 <- matriculas_no_1320 |>
      dplyr::filter(NU_ANO_CENSO == ano2) |>
      dplyr::filter(TP_ETAPA_ENSINO == 1) |>
      dplyr::count(TP_ETAPA_ENSINO)

   matricula0a3 <- matricula0a3$n |> sum()

# Calculando o indicador 1B

   indicador_1B = round(matricula0a3/qtde0a3,4)*100


  mensagem1 <- paste0("O indicador 1B, da Meta 1 do Plano Nacional de Educação do",
                    " município ", cidade2, ", que mede o percetual",
                    " de crianças de 0 a 3 anos matriculados",
                    " em creches é de ", indicador_1B, "%.")

print(mensagem1)

# Meta 1: Indicador 1A

#  Populacao de 4 a 5 anos

qtde4a5 <- estimativas_por_idade |>
  dplyr::filter(Faixa_Etaria=="4 a 5 anos") |>
  #    dplyr::group_by(Faixa_Etaria) |>
  dplyr::summarise(
    Populacao = sum(`2015`)
  ) |> as.numeric()

# Matricula de 4 a 5 anos

matricula4a5 <- matriculas_no_1320 |>
  dplyr::filter(NU_ANO_CENSO == ano2) |>
  dplyr::filter(TP_ETAPA_ENSINO == 2) |>
  dplyr::count(TP_ETAPA_ENSINO)

matricula4a5 <- matricula4a5$n |> sum()


indicador_1A <- matricula4a5/qtde4a5*100

mensagem2 <- paste0("O indicador 1A, da Meta 1 do Plano Nacional de Educação do",
                    " município ", cidade2, " que mede o percetual",
                    " de crianças de 4 a 5 anos matriculados",
                    " em creches é de ", round(indicador_1A, 2), "%.")

print(mensagem2)


Meta_1 <- (matricula0a3 + matricula4a5)/(qtde0a3  + qtde4a5)

mensagem3 <- paste0("O município de ", cidade2, " alcançou ",
                    round(Meta_1, 2), "% referente à Meta 1 do Plano Nacional de Educação",
                    " no ano de ", ano2)

print(mensagem3)
