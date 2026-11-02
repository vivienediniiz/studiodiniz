# Modelo do banco (Supabase)

Rascunho inicial da Fase 1. Todas as tabelas têm `id` (uuid), `created_at` e `updated_at`. Row Level Security ativo, liberando acesso apenas ao usuário autenticado.

## produtos
| Campo | Tipo | Observação |
|---|---|---|
| nome | text | obrigatório |
| sku | text | único |
| codigo_barras | text | opcional |
| categoria | text | Impressão 3D, Papelaria |
| descricao | text | |
| custo | numeric(10,2) | |
| preco_varejo | numeric(10,2) | |
| preco_atacado | numeric(10,2) | |
| estoque_atual | integer | padrão 0 |
| estoque_minimo | integer | |
| material | text | padrão PLA (produtos 3D) |
| ncm | text | padrão 39269090 |
| cfop_intra | text | 5101 |
| cfop_inter | text | 6101 |
| csosn | text | 400 |
| unidade | text | UN |
| ativo | boolean | padrão true |
| origem | text | xml, manual |

## produto_imagens
- produto_id (fk produtos), url, ordem

## servicos
| Campo | Tipo | Observação |
|---|---|---|
| nome | text | obrigatório |
| sku | text | único |
| tipo | text | site, landing_page, social_media, pacote |
| preco | numeric(10,2) | |
| prazo_dias | integer | |
| descricao | text | |
| ativo | boolean | padrão true |

## clientes
| Campo | Tipo | Observação |
|---|---|---|
| nome | text | obrigatório |
| telefone | text | |
| email | text | |
| documento | text | CPF ou CNPJ |
| endereco | text | |
| tipo | text | consumidor, atacado |
| observacoes | text | |

## vendas
| Campo | Tipo | Observação |
|---|---|---|
| cliente_id | fk clientes | opcional |
| subtotal | numeric(10,2) | |
| desconto_percentual | numeric(5,2) | |
| total | numeric(10,2) | |
| forma_pagamento | text | pix, credito, debito, mercado_pago |
| status | text | concluida, cancelada |
| data_venda | timestamptz | |

## venda_itens
- venda_id (fk vendas)
- produto_id (fk produtos) ou servico_id (fk servicos)
- quantidade integer
- preco_unitario numeric(10,2)

## pedidos
| Campo | Tipo | Observação |
|---|---|---|
| cliente_id | fk clientes | |
| venda_id | fk vendas | opcional |
| status | text | pago, em_producao, enviado |
| data_prazo | date | |
| observacoes | text | |

## movimentacoes_estoque
| Campo | Tipo | Observação |
|---|---|---|
| produto_id | fk produtos | |
| tipo | text | entrada, saida, ajuste, devolucao |
| quantidade | integer | |
| origem | text | venda, compra, ajuste manual |
| referencia_id | uuid | id da venda ou da compra |

## Regras principais

- Ao concluir uma venda, criar uma movimentação de saída para cada produto e atualizar `estoque_atual`.
- Cancelar uma venda gera uma devolução e restaura o estoque.
- Preço de atacado é aplicado automaticamente quando o cliente for do tipo atacado.
- Produtos inativos não aparecem no caixa nem no catálogo.
