# Escopo da Fase 1 (MVP)

Objetivo: substituir o controle atual de vendas e estoque e começar a usar o sistema no dia a dia.

## Incluído

### Produtos
- Cadastro com nome, SKU, categoria, descrição e fotos
- Custo, preço de varejo e preço de atacado
- Estoque atual e estoque mínimo, com alerta
- Dados fiscais: NCM, CFOP, CSOSN e unidade
- Status ativo ou inativo
- Importação em lote por XML da gráfica parceira
- Cadastro manual

### Serviços
- Cadastro com nome, tipo (site, landing page, social media, pacote), valor e prazo
- Serviços não controlam estoque

### Clientes
- Nome, telefone, e-mail, CPF ou CNPJ e endereço
- Tipo: consumidor final ou atacado (define a tabela de preço)

### Frente de caixa (PDV)
- Busca por nome ou SKU
- Carrinho com quantidade
- Desconto em percentual
- Forma de pagamento: Pix, cartão de crédito, cartão de débito ou Mercado Pago
- Baixa automática de estoque ao concluir a venda
- Registro da venda com data e forma de pagamento

### Pedidos
- Status: pago, em produção, enviado
- Lista com filtro por status

### Painel
- Vendas do dia e do mês
- Pedidos em aberto
- Alertas de estoque
- Gráfico dos últimos 7 dias

### Usuário
- Login único com e-mail e senha
- Row Level Security ativo no Supabase

### Layout
- Responsivo, com barra inferior no celular
- Versão PWA instalável

## Fora da Fase 1

- Orçamentos e catálogo com finalização pelo WhatsApp (Fase 2)
- Briefing por link (Fase 2)
- Agenda com notificações por push e e-mail (Fase 2)
- Produção 3D, compras e financeiro (Fase 2)
- Conexão com redes sociais e agendamento de posts (Fase 3)
- Integrações com Yampi, Shopee, TikTok Shop e Mercado Pago (Fase 3)
- Nota fiscal (Fase 4)

## Critérios de aceite

- Cadastrar um produto e uma venda no caixa em menos de um minuto
- O estoque baixa automaticamente após cada venda
- O painel mostra o total do dia com as vendas registradas
- O sistema funciona no celular e no computador
