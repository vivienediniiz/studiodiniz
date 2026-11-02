# Studio Diniz · Sistema de Gestão

Sistema de uso próprio para o Studio Diniz: impressão 3D, papelaria personalizada e serviços digitais (sites, social media).

Não é um produto para venda. Atende um único usuário, a própria Viviene.

## Visão geral

- Frente de caixa (PDV)
- Cadastro de produtos (importação XML da gráfica e cadastro manual)
- Cadastro de serviços (sites, social media, pacotes)
- Clientes, pedidos com status (pago, em produção, enviado), briefing e agenda
- Orçamentos e catálogo para o cliente, com finalização pelo WhatsApp
- Painel com vendas diárias e mensais
- Conexão com redes sociais e agendamento de posts (fase posterior)

## Stack

- Next.js, Tailwind CSS, Supabase, Netlify, n8n
- Mercado Pago para pagamentos
- PWA, instalável no tablet e no computador de balcão

## Identidade visual

- Texto principal: `#3E2723` (Deep Espresso)
- Fundo: `#FBF4EB` (Champagne)
- Botões e destaque: `#C43670` (Raspberry Rose)
- Rosas de apoio: `#F7CFE3`, `#E59CC2`, `#F4C9D6`
- Neutro de bordas: `#D6CACB`
- Sem amarelo
- Efeito liquid glass, botões arredondados com transição
- Títulos: Recoleta (reserva: Fraunces)

## Estrutura do repositório

- `docs/escopo-fase-1.md`: escopo do MVP
- `docs/modelo-banco.md`: tabelas previstas no Supabase
- `prototipo/index.html`: protótipo estático das telas (painel, caixa, catálogo e pedidos)

## Como ver o protótipo

Abra `prototipo/index.html` no navegador. Para a fonte Recoleta aparecer corretamente, coloque o arquivo `Recoleta.otf` na mesma pasta.
