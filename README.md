# Super-Conversor-de-Imagens-Universal-PowerShell.
Um script PowerShell para converter em lote arquivos AI, EPS, CDR, etc., para JPG, PNG, PDF, SVG e EPS.
================================================================
Manual de Usuário: Super Conversor de Imagens Universal
================================================================

1. O que este script faz?
-------------------------
O Super Conversor de Imagens Universal é um poderoso script para Windows que automatiza a conversão em lote de arquivos de imagem. Ele pega uma pasta cheia de arquivos de diferentes formatos (vetoriais como .ai, .eps, .cdr, .svg, e raster como .psd, .jpg, .png) e converte todos eles para cinco formatos de saída universais: JPG, PNG, PDF, EPS e SVG.

É a ferramenta perfeita para designers, arquivistas ou qualquer pessoa que precise padronizar uma grande coleção de arquivos de imagem com um único clique.


2. Pré-requisitos: O que você precisa instalar?
------------------------------------------------
Para que a mágica aconteça, o script depende de três programas gratuitos e poderosos. Você PRECISA instalá-los antes de executar o script.

### Instalação Obrigatória (3 Passos): ###

Passo 1: ImageMagick (O Canivete Suíço das Imagens)
- O que é? Usado para a maioria das conversões de imagem, especialmente para criar JPGs e PNGs.
- Como instalar:
    1. Vá para a página de download do ImageMagick: https://imagemagick.org/script/download.php
    2. Na seção "Windows Binary Release", baixe o primeiro arquivo da lista (geralmente algo como ImageMagick-7.X.X-Q16-HDRI-x64-dll.exe ).
    3. Execute o instalador. IMPORTANTE: Durante a instalação, marque a caixa que diz "Add application directory to your system path (PATH)". Isso é crucial!

Passo 2: Inkscape (O Mestre dos Vetores)
- O que é? Essencial para converter formatos vetoriais como .ai, .cdr, .eps e .svg.
- Como instalar:
    1. Vá para a página de download do Inkscape: https://inkscape.org/release/inkscape-1.3/
    2. Baixe a versão para Windows (instalador .exe ).
    3. Execute o instalador e aceite as opções padrão.

Passo 3: Ghostscript (O Intérprete de PDF e EPS)
- O que é? Ajuda o ImageMagick e o Inkscape a lerem arquivos .pdf e, mais importante, arquivos .eps complicados.
- Como instalar:
    1. Vá para a página de download do Ghostscript: https://www.ghostscript.com/releases/gsdnld.html
    2. Baixe o "PostScript and PDF interpreter/renderer" para Windows (64-bit ).
    3. Execute o instalador e aceite as opções padrão.

---
### PASSO CRÍTICO: Verifique os Caminhos de Instalação! ###

O script precisa saber exatamente onde cada um desses três programas foi instalado. Se você instalou os programas em um local diferente do padrão, o script irá falhar.

Como verificar e corrigir:
1. Abra o arquivo `Converter.ps1` com o Bloco de Notas (clique com o botão direito -> Abrir com -> Bloco de Notas).

2. Localize a seção de caminhos no topo do script. Ela se parece com isto:
   # --- CAMINHOS DAS DEPENDÊNCIAS ---
   $inkscapePath = "C:\Program Files\Inkscape\bin\inkscape.exe"
   $magickPath   = "C:\Program Files\ImageMagick-7.1.2-Q16-HDRI\magick.exe"
   $gsPath       = "C:\Program Files\gs\gs10.05.1\bin\gswin64c.exe"

3. Verifique cada caminho no seu computador. Por exemplo, para o Inkscape:
   - Abra o Explorador de Arquivos.
   - Navegue até C:\Program Files\Inkscape\bin.
   - Confirme se o arquivo inkscape.exe está lá.

4. Se um caminho estiver diferente, corrija-o no script.
   - Exemplo: Se você instalou o Ghostscript em D:\Programas\gs\, você deve alterar a linha $gsPath para:
     $gsPath = "D:\Programas\gs\gs10.05.1\bin\gswin64c.exe"
   - Dica: A maneira mais fácil de obter o caminho correto é navegar até o arquivo (.exe), clicar com o botão direito sobre ele segurando a tecla Shift e selecionar "Copiar como caminho". Depois, cole-o dentro das aspas no script.

5. Salve o arquivo após fazer as alterações.

Fazer esta verificação garante que o script encontrará as ferramentas necessárias para funcionar.
---

3. Como Usar o Script
----------------------
O processo é muito simples.

Passo 1: Prepare sua pasta
1. Crie uma nova pasta em qualquer lugar do seu computador (ex: C:\Meus_Arquivos_Para_Converter).
2. Copie todos os arquivos de imagem que você deseja converter para dentro desta pasta.
3. IMPORTANTE: Não crie as pastas JPG, PNG, etc., manualmente. O script fará isso por você.

Passo 2: Coloque o Script na Pasta
1. Salve o código do script em um arquivo chamado `Converter.ps1`.
2. Mova o arquivo `Converter.ps1` para dentro da pasta que você criou no Passo 1, junto com suas imagens.

Sua pasta deve ficar assim:
Meus_Arquivos_Para_Converter/
|-- Converter.ps1
|-- imagem1.ai
|-- logo.eps
|-- foto.jpg
|-- ...e todos os seus outros arquivos

Passo 3: Execute o Script
1. Abra a pasta.
2. Clique com o botão direito do mouse no arquivo `Converter.ps1`.
3. No menu que aparece, selecione "Executar com PowerShell".

Uma janela azul do PowerShell aparecerá e começará a trabalhar.

Passo 4: Aguarde e Veja a Mágica
O script pode levar vários minutos para ser concluído. Seja paciente! O objetivo é o resultado e a qualidade.

Quando terminar, o script exibirá um relatório final com as estatísticas e a mensagem "Pressione Enter para continuar...". Suas novas pastas (JPG, PNG, PDF, EPS, SVG) estarão prontas.


4. Entendendo os Resultados e Possíveis Falhas
-----------------------------------------------
- Sucesso Total: Se as estatísticas finais mostrarem 100% para todas as pastas, parabéns!
- Falhas em .ai e .cdr: É NORMAL que alguns arquivos .ai (Adobe Illustrator) e .cdr (CorelDRAW) mais recentes não sejam convertidos para formatos vetoriais (PDF, EPS, SVG). Isso acontece porque são formatos proprietários. O script ainda tentará criar o JPG e o PNG a partir da pré-visualização.
- Avisos (Warning): É comum ver avisos do Ghostscript ou ImageMagick. Na maioria dos casos, estes avisos podem ser ignorados e não afetam a qualidade do arquivo final.


5. Contribuição
----------------
Este script foi o resultado de um intenso processo de depuração e engenharia. Um agradecimento especial ao usuário que, com sua paciência e diagnósticos precisos, foi fundamental para a criação da versão final e funcional desta ferramenta.
