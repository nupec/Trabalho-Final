# 1. Escolha uma das bases utilizadas no curso ou uma base própria.
# 
# 
# 
# 2. Crie um novo projeto e o conecte com o Github, em um repositório aberto.
# 
# 
# 3. Faça uma análise da base escolhida para responder alguma pergunta de interesse (veja o tópico "Bases de dados"). 
# 
# 
# 4. A comunicação dos resultados deve ser feita no README.Rmd do seu repositório. O README.Rmd é um arquivo R Markdown localizado na raiz do seu repositório. Se ele não existir, rode o comando usethis::use_readme_rmd() para criá-lo.
# 
# 
# 5. Você deve submeter aqui no Classroom apenas o link para o repositório criado no Github. 
# 
# 
# 6. O certificado será enviado até duas semanas após a data limite da entrega final, apenas a quem entregar esta atividade.
# 
# 
# 7. Os 2 trabalhos mais legais ganharão uma vaga para qualquer curso da Curso-R. Serão avaliados:
#   
#   
#   - Análise crítica: entendimento da base e do problema em estudo.
# - Organização: clareza na comunicação dos resultados e acesso aos arquivos utilizados na análise.
# - Técnica: conhecimento do conteúdo visto neste curso.
# - Criatividade: abordagem escolhida para a análise e para a comunicação dos resultados.
# 
# 
# ## Bases de dados
# 
# 
# As bases estão na pasta "data", do material do curso. 
# 
# 
# _______________________________________________________________________________________________________
# ** Secretaria de Segurança Pública (SSP) de São Paulo **
#   
#   
#   Descrição: número de ocorrências mensais de diversos crimes de 2002 a 2020 (abril) no nível delegacia para todo o Estado de São Paulo.
# 
# 
# Principais variáveis:
#   
#   
#   - Número de ocorrências mensais (furtos, roubos, homicídios etc) 
# - Delegacia onde a ocorrência foi registrada
# - Município e região do estado da delegacia
# - Mês e ano
# 
# 
# Principais características
# 
# 
# - Séries temporais
# - Dados geográficos
# - Oportunidade para construção de mapas
# 
# 
# Sugestões de análises
# 
# 
# - Visualizar as séries de criminalidade
# - Avaliar se os níveis de criminalidade mudaram durante a quarentena
# 
# 
# _______________________________________________________________________________________________________
# ** Companhia Ambiental do Estado de São Paulo (CETESB) **
#   
#   
#   Descrição: concentração horária de alguns poluentes em algumas estações de monitoramento na Região Metropolitana de São Paulo de jan/2017 a mai/2020.
# 
# 
# Principais variáveis:
#   
#   
#   - Concentração horária de CO, NO, NO2, O3 e MP10
# - Data e hora da medição
# - Estação de monitoramento
# - Latitude e longitude das estações de monitoramento
# 
# 
# Principais características
# 
# 
# - Séries temporais
# - Oportunidade para construção de mapas
# - Oportunidade para vários tipos de sumarização (dado que as medidas são horárias)
# 
# 
# Sugestões de análises
# 
# 
# - Visualizar cada uma das séries de poluentes
# - Avaliar se os níveis de poluição mudaram durante a quarentena
# 
# 
# _______________________________________________________________________________________________________
# ** Análise de Crédito **
#   
#   
#   Descrição: base com características de clientes que solicitaram empréstimo em uma financeira.
# 
# 
# Principais variáveis:
#   
#   
#   - Classificação de cliente bom/ruim
# - Variáveis demográficas e financeiras do cliente
# - Tempo e valor do empréstimo solicitado
# 
# 
# Principais características
# 
# 
# - Oportunidade de modelagem preditiva
# - Problema de classificação (cliente bom/cliente ruim)
# - Variáveis explicativas númericas e categóricas
# 
# 
# Sugestões de análises
# 
# 
# - Avaliar quais características definem um cliente bom ou ruim
# - Construir um modelo para prever clientes bons e ruins
# 
# 
# _______________________________________________________________________________________________________
# ** Pokémon **
#   
#   
#   Descrição: base com os status base de todos os pokémon da primeira à sétima geração. 
# 
# 
# Principais variáveis:
#   
#   
#   - Nome, tipo e geração de cada pokémon
# - Status base (altura, peso, hp, ataque, defesa etc)
# - Cor base e imagem de cada pokémon
# 
# 
# Principais características
# 
# 
# - Tema leve e descontraído (caso o mundo já esteja pesado demais)
# - Oportunidade de trabalhar com cores e imagens
# - Variáveis explicativas númericas e categóricas
# 
# 
# Sugestões de análises
# 
# 
# - Análise descritiva dos pokémon, por tipo e/ou geração
# - Analisar quais características estão correlacionadas (por exemplo, pokémon altos e pesados tendem a ter defesa maior?)
# 
# 
# _______________________________________________________________________________________________________
# ** Sua base **
#   
#   
#   Você também pode usar uma base sua na entrega final. Só não se esqueça de descrever bem o problema e as variáveis envolvidas.
