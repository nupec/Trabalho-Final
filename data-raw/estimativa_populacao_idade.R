library(tidyverse)
library(stringr)
library(readxl)
library(readr)
library(data.table)
library(forcats)
library(janitor) # pacote útil para faxinar os dados
library(dplyr)
library(ggplot2)

# 1) Importação e tratamento das base de dados
df_projecoes = read_excel("data/popIDADES.xls", skip = 195, n_max = 92)
idades <- df_projecoes[1] # Esta variável será reutilizada posteriormente

# 1.1) Calculando indices das idades
 indices <- df_projecoes # inicializando a variável índice

  p <- NULL  # inicializando o contador
  
      for (p in 2:length(df_projecoes)) {
        indices[p] = df_projecoes[p]/apply(df_projecoes[ , p], 2, sum)
      } 

  indices <- indices %>% select("IDADE", "2014":"2020")

# 1.2) Importando os códigos das cidades
  codigos_cidades <- read_excel("data/CODIGO_MUNICIPIO.xls")

# codigos_cidades_arruamados <- codigos_cidades <-  codigos_cidades %>% 
#                     clean_names() 

# glimpse(codigos_cidades) 

# 1.2) O próximo passo é importar a popuçação dos municípios brasileiros 
  municipios_pop_anos_BR <- read_excel("data/popESTIMADA.xlsx")

# glimpse(populacao_municipios)

# 1.3) Selecionando as cidade a serem analisadas utilizando o código dos municípios

# As cidade selecionadas são: São eles: Itacoatiara, Itapiranga, Silves, São Sebastião,
# Nova Olinda do Norte, Urucará e Urucurituba
  cod_cidades_selecionadas <- c("1301902", "1302009", "1303106", 
                                "1304005", "1304302", "1304401")

  cidades_pop_ano <-  municipios_pop_anos_BR %>% 
                      filter(Cod %in% cod_cidades_selecionadas) %>% 
                      select( "Municipio", "2014":"2020")

# 1.4) Definiando o período e cidades a serem analisadas

# De posse da população estimada dos municípios selecionados e dos índices de distribuição das 
# idades, criam-se um data frames apenas com os anos de interesse de vigência do PNE (2014-2024).
# A projeção da população brasielira possui dadosde 2010 a 2050, enquanto a estimativa municipal, 
# possui dados de 2001 a 2020. Portanto, futuramente será necessário estimar a população 
# dos municípios para os anos faltantes. Por padrão, vamos trabalhar com os anos 2014 a 2020.

# write.csv2(indices, "output/indices.csv")
# write.csv2(cidades_selecionadas, "output/cidades_selecionadas.csv")


# 2) Função para estimar a distribuição das idades [de 0 a +90 anos] de uma determinada cidade

Anos          <- names(cidades_pop_ano)[2:length(cidades_pop_ano)]
Nomes_cidades <- cidades_pop_ano %>% select(Municipio)

# 2.1) Definir cidade a ser analisada

# 2.2) Iniciar variáveis 

# 2.3) Estimativa das idade ao longo dos anos
est <- function(cidade){
  i=1
  ano <- Anos[i]
  estimativa_cidade_idade = indices[ano]
 
    for (i in 1:length(Anos)) {
      # 2.1) Define-se a cidade a ser analisada
        ano <- Anos[i]
          pop_cidade <- cidades_pop_ano       %>% 
            select(Municipio, all_of(ano),)   %>% 
              filter(Municipio == cidade)     %>% 
                select(-Municipio)            %>% 
                  as.numeric()
    
# 2.3) Estimativa das idades da populacao da IDADE X ANO
    estimativa_cidade_idade[i] <-  round(as.numeric(pop_cidade)*indices[ , all_of(ano)],0)
      
    }  
  
  estimativa_cidade_idade <-  estimativa_cidade_idade   %>%  
                                cbind(idades)           %>% 
                                relocate(IDADE, )
  
  estimativa_cidade_idade["Local"] = cidade 

    return(estimativa_cidade_idade)
}
 
      estimativas_por_idade = NULL
 
for (j in 1:nrow(Nomes_cidades)) {
    base_aux <- est(as.character(Nomes_cidades[j,]))
      estimativas_por_idade <- rbind(base_aux, estimativas_por_idade) 
} 
      base_aux = NULL
       

# População da Região por faixa-etária ------------------------------------

    estimativas_por_idade <- estimativas_por_idade %>%
        mutate(
           Faixa_Etaria = case_when(
             IDADE %in% 0:3 ~ "0 a 3 anos",
             IDADE %in% 4:5 ~ "4 a 5 anos",
             IDADE %in% 6:14 ~ "6 a 14 anos",
             IDADE %in% 15:17 ~ "15 a 17 anos",
             IDADE >17 ~ "mais de 18 anos"))
      
       tabela <- estimativas_por_idade %>%
         select(-IDADE,-Local) %>% 
         dplyr::group_by(Faixa_Etaria) %>%
         dplyr::summarise(dplyr::across(.fns = sum, .names = "POP_{.col}"))
       
       tabela <- tabela %>%
         mutate(Faixa_Etaria = factor(
           Faixa_Etaria,
           levels = c("0 a 3 anos",
                      "4 a 5 anos",
                      "6 a 14 anos",
                      "15 a 17 anos",
                      "mais de 18 anos"),
           ordered = TRUE
         )) %>% 
         arrange(Faixa_Etaria)

# write.csv2(indices, "output/estimativas_por_idade.csv")
 
# Calculando as estimativas de idade para todas as cidades em análise
# Estimativa da população por faixa estária

# Alguns exemplos de tabela -----------------------------------------------
    
    print(paste0("A tabela abaixo apresenta a estimativa da população das cidades da Região Adminstrativa de Itacoatiara, entre os anos 2014 e 2020, por faixa-etária"))
       
    tabela %>% 
       arrange(Faixa_Etaria) %>%  
       knitr::kable()
    
    # tabela %>% 
    #    arrange(Faixa_Etaria) %>%  
    #    DT::datatable()
    # 
    # tabela %>% 
    #    arrange(Faixa_Etaria) %>% 
    #    reactable::reactable()
    # 

# População por Cidade e Faixa-Etária -------------------------------------
    
    Nomes_cidades   
    
    filtro_cidade = "Itapiranga"
    
    tabela_cidade_filtrada <- estimativas_por_idade %>% 
      filter(Local == filtro_cidade)
    
    tabela_cidade_filtrada <- tabela_cidade_filtrada %>%
      select(-IDADE,-Local) %>% 
      group_by(Faixa_Etaria) %>%
      summarise(dplyr::across(.fns = sum, .names = "POP_{.col}")) 
    

    print(paste0("A tabela abaixo apresenta a estimativa da população da cidade de ", filtro_cidade,
           " entre os anos 2014 e 2020, por faixa-etária."))
    
      # tabela_cidade_filtrada %>% 
      # arrange(Faixa_Etaria) %>% 
      # reactable::reactable()
    
    tabela_cidade_filtrada %>% 
      arrange(Faixa_Etaria) %>% 
      knitr::kable()
  