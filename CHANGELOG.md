# Alterações no projeto

Todas as alterações relevantes neste projeto serão documentadas neste arquivo.

O formato baseia-se em [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) e este projeto segue [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Adicionado

### Alterado

### Descontinuado

### Removido

### Corrigido

### Segurança

## [1.0.0] - 2026-08-13

### Adicionado

- Infraestrutura reutilizável baseada em Docker para aplicações, com ambientes dedicados de produção e desenvolvimento;
- Imagem da aplicação em múltiplos estágios;
- Definições do Docker Compose, diretórios de dados persistentes, templates de configuração, exemplos de certificados SSL e um ponto de entrada para a aplicação;
- Comandos no Makefile para construir, iniciar, interromper, manter e inspecionar os ambientes conteinerizados;
- Documentação de instalação, contribuição, segurança, suporte, licenciamento e uso do projeto;
- Guia de uso para operação, persistência, manutenção e diagnóstico dos ambientes de desenvolvimento e produção;
- Atributos do Git e regras de arquivos ignorados para manter um comportamento consistente no repositório;

### Alterado

- Padronização das nomenclaturas do projeto, dos containers, serviços, redes, volumes, variáveis de ambiente e arquivos;
- Refinamento da estrutura dos arquivos de ambiente, da configuração dos containers, do comportamento do ponto de entrada e da documentação do projeto;
- Diretrizes de contribuição padronizadas, preservando requisitos, exemplos e verificações específicos do projeto;

### Corrigido

- Correção do comportamento do Makefile e da organização das variáveis de ambiente;
