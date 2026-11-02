-- Studio Diniz · Estrutura inicial (Fase 1)
-- Uso único: um usuário autenticado, com RLS ativo em todas as tabelas.

create extension if not exists "pgcrypto";

-- Atualiza updated_at automaticamente
create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- ============================================================
-- PRODUTOS
-- ============================================================
create table public.produtos (
  id uuid primary key default gen_random_uuid(),
  nome text not null,
  sku text not null unique,
  codigo_barras text,
  categoria text check (categoria in ('Impressão 3D', 'Papelaria')),
  descricao text,
  custo numeric(10,2) not null default 0,
  preco_varejo numeric(10,2) not null default 0,
  preco_atacado numeric(10,2) not null default 0,
  estoque_atual integer not null default 0,
  estoque_minimo integer not null default 0,
  material text default 'PLA',
  ncm text default '39269090',
  cfop_intra text default '5101',
  cfop_inter text default '6101',
  csosn text default '400',
  unidade text default 'UN',
  ativo boolean not null default true,
  origem text not null default 'manual' check (origem in ('xml', 'manual')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.produto_imagens (
  id uuid primary key default gen_random_uuid(),
  produto_id uuid not null references public.produtos(id) on delete cascade,
  url text not null,
  ordem integer not null default 0,
  created_at timestamptz not null default now()
);

-- ============================================================
-- SERVIÇOS
-- ============================================================
create table public.servicos (
  id uuid primary key default gen_random_uuid(),
  nome text not null,
  sku text not null unique,
  tipo text not null check (tipo in ('site', 'landing_page', 'social_media', 'pacote')),
  preco numeric(10,2) not null default 0,
  prazo_dias integer,
  descricao text,
  ativo boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- ============================================================
-- CLIENTES
-- ============================================================
create table public.clientes (
  id uuid primary key default gen_random_uuid(),
  nome text not null,
  telefone text,
  email text,
  documento text,
  endereco text,
  tipo text not null default 'consumidor' check (tipo in ('consumidor', 'atacado')),
  observacoes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- ============================================================
-- VENDAS
-- ============================================================
create table public.vendas (
  id uuid primary key default gen_random_uuid(),
  cliente_id uuid references public.clientes(id) on delete set null,
  subtotal numeric(10,2) not null default 0,
  desconto_percentual numeric(5,2) not null default 0 check (desconto_percentual between 0 and 100),
  total numeric(10,2) not null default 0,
  forma_pagamento text not null check (forma_pagamento in ('pix', 'credito', 'debito', 'mercado_pago')),
  status text not null default 'concluida' check (status in ('concluida', 'cancelada')),
  data_venda timestamptz not null default now(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.venda_itens (
  id uuid primary key default gen_random_uuid(),
  venda_id uuid not null references public.vendas(id) on delete cascade,
  produto_id uuid references public.produtos(id) on delete set null,
  servico_id uuid references public.servicos(id) on delete set null,
  quantidade integer not null check (quantidade > 0),
  preco_unitario numeric(10,2) not null,
  created_at timestamptz not null default now(),
  -- cada item é um produto OU um serviço, nunca os dois
  constraint venda_itens_produto_ou_servico check (
    (produto_id is not null and servico_id is null) or
    (produto_id is null and servico_id is not null)
  )
);

-- ============================================================
-- PEDIDOS
-- ============================================================
create table public.pedidos (
  id uuid primary key default gen_random_uuid(),
  cliente_id uuid references public.clientes(id) on delete set null,
  venda_id uuid references public.vendas(id) on delete set null,
  status text not null default 'pago' check (status in ('pago', 'em_producao', 'enviado')),
  data_prazo date,
  observacoes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- ============================================================
-- MOVIMENTAÇÕES DE ESTOQUE (histórico)
-- ============================================================
create table public.movimentacoes_estoque (
  id uuid primary key default gen_random_uuid(),
  produto_id uuid not null references public.produtos(id) on delete cascade,
  tipo text not null check (tipo in ('entrada', 'saida', 'ajuste', 'devolucao')),
  quantidade integer not null,
  origem text not null check (origem in ('venda', 'compra', 'ajuste_manual')),
  referencia_id uuid,
  created_at timestamptz not null default now()
);

-- ============================================================
-- Índices
-- ============================================================
create index on public.produto_imagens (produto_id, ordem);
create index on public.venda_itens (venda_id);
create index on public.vendas (data_venda);
create index on public.pedidos (status);
create index on public.movimentacoes_estoque (produto_id, created_at);

-- ============================================================
-- Triggers de updated_at
-- ============================================================
create trigger produtos_updated_at before update on public.produtos
  for each row execute function public.set_updated_at();
create trigger servicos_updated_at before update on public.servicos
  for each row execute function public.set_updated_at();
create trigger clientes_updated_at before update on public.clientes
  for each row execute function public.set_updated_at();
create trigger vendas_updated_at before update on public.vendas
  for each row execute function public.set_updated_at();
create trigger pedidos_updated_at before update on public.pedidos
  for each row execute function public.set_updated_at();

-- ============================================================
-- Row Level Security: somente o usuário autenticado
-- ============================================================
alter table public.produtos enable row level security;
alter table public.produto_imagens enable row level security;
alter table public.servicos enable row level security;
alter table public.clientes enable row level security;
alter table public.vendas enable row level security;
alter table public.venda_itens enable row level security;
alter table public.pedidos enable row level security;
alter table public.movimentacoes_estoque enable row level security;

create policy "acesso_autenticado" on public.produtos
  for all to authenticated using (true) with check (true);
create policy "acesso_autenticado" on public.produto_imagens
  for all to authenticated using (true) with check (true);
create policy "acesso_autenticado" on public.servicos
  for all to authenticated using (true) with check (true);
create policy "acesso_autenticado" on public.clientes
  for all to authenticated using (true) with check (true);
create policy "acesso_autenticado" on public.vendas
  for all to authenticated using (true) with check (true);
create policy "acesso_autenticado" on public.venda_itens
  for all to authenticated using (true) with check (true);
create policy "acesso_autenticado" on public.pedidos
  for all to authenticated using (true) with check (true);
create policy "acesso_autenticado" on public.movimentacoes_estoque
  for all to authenticated using (true) with check (true);
