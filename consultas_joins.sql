USE exercicio2;

-- 1. Pedidos realizados no ano de 2014 (NATURAL JOIN)
SELECT codPedido, dataRealizacao, dataEntrega, nomeFantasia
FROM pedido
NATURAL JOIN fornecedor
WHERE YEAR(dataRealizacao) = 2014;

-- 2. Vendedores da cidade de ‘Apucarana’ (INNER JOIN)
SELECT v.nome, v.dataNascimento, c.nome AS cidade
FROM vendedor v
INNER JOIN cidade c ON v.codCidade = c.codCidade
WHERE c.nome = 'Apucarana';

-- 3. Vendas do produto ‘Cal’ (NATURAL JOIN)
SELECT v.codVenda, v.dataVenda, vd.nome, iv.numeroLote, p.descricao
FROM venda v
NATURAL JOIN itemVenda iv
NATURAL JOIN produto p
JOIN vendedor vd ON v.codVendedor = vd.codVendedor
WHERE p.descricao = 'Cal';

-- 4. Produtos da classe ‘Acabamentos’
SELECT cl.sigla, cl.nome, p.codProduto, p.descricao, p.estoqueMinimo
FROM classe cl
JOIN produto p ON cl.codClasse = p.codClasse
WHERE cl.nome = 'Acabamentos';

-- 5. Pedidos do fornecedor ‘Incepa’
SELECT f.nomeFantasia, p.codPedido, p.dataRealizacao, p.dataEntrega
FROM fornecedor f
JOIN pedido p ON f.codFornecedor = p.codFornecedor
WHERE f.nomeFantasia = 'Incepa';

-- 6. Todos os produtos e, quando existirem, as vendas relativas ao produto (LEFT JOIN)
SELECT p.codProduto, p.descricao, iv.codVenda
FROM produto p
LEFT JOIN itemVenda iv ON p.codProduto = iv.codProduto;

-- 7. Todos os fornecedores e, quando existirem, os seus pedidos (LEFT JOIN)
SELECT f.nomeFantasia, p.codPedido, p.dataEntrega
FROM fornecedor f
LEFT JOIN pedido p ON f.codFornecedor = p.codFornecedor;

-- 8. Todos os departamentos e seus vendedores, incluindo departamentos sem vendedores (RIGHT JOIN)
SELECT d.nome AS departamento, d.localizacao, v.nome AS funcionario, v.dataNascimento
FROM vendedor v
RIGHT JOIN departamento d ON v.codDepartamento = d.codDepartamento;

-- 9. Todos os clientes e suas compras, incluindo clientes sem compras (RIGHT JOIN/UNION)
SELECT cf.nome AS cliente, v.codVenda
FROM clienteFisico cf
RIGHT JOIN cliente c ON cf.codCliente = c.codCliente
LEFT JOIN venda v ON c.codCliente = v.codCliente

UNION

SELECT cj.nomeFantasia AS cliente, v.codVenda
FROM clienteJuridico cj
RIGHT JOIN cliente c ON cj.codCliente = c.codCliente
LEFT JOIN venda v ON c.codCliente = v.codCliente;

-- 10. Todas as classes e, quando existirem, os produtos da classe (LEFT JOIN)
SELECT cl.*, p.descricao, pl.precoCusto
FROM classe cl
LEFT JOIN produto p ON cl.codClasse = p.codClasse
LEFT JOIN produtoLote pl ON p.codProduto = pl.codProduto;

-- 11. Todos os estados e, quando existirem, suas cidades (RIGHT JOIN)
SELECT e.*, c.*
FROM cidade c
RIGHT JOIN estado e ON c.siglaEstado = e.siglaEstado;

-- 12. Todos os produtos e seus lotes quando existirem (LEFT JOIN)
SELECT p.codProduto, p.descricao, pl.numeroLote, pl.validade
FROM produto p
LEFT JOIN produtoLote pl ON p.codProduto = pl.codProduto;

-- 13. Todas as cidades e, quando existirem, os vendedores nela cadastrados (RIGHT JOIN)
SELECT c.codCidade, c.nome AS cidade, c.siglaEstado, v.nome AS vendedor, v.endereco, v.telefone
FROM vendedor v
RIGHT JOIN cidade c ON v.codCidade = c.codCidade;

-- 14. Todos os vendedores e, quando existirem, as vendas sob responsabilidade do vendedor (LEFT JOIN)
SELECT v.nome, v.dataContratacao, ve.codVenda, ve.dataVenda
FROM vendedor v
LEFT JOIN venda ve ON v.codVendedor = ve.codVendedor;

-- 15. Todas as cidades e os clientes nela cadastrados, quando existirem (RIGHT JOIN/UNION)
SELECT c.nome AS cidade, cf.nome AS cliente
FROM clienteFisico cf
RIGHT JOIN cliente cl ON cf.codCliente = cl.codCliente
RIGHT JOIN cidade c ON cl.codCidade = c.codCidade

UNION

SELECT c.nome AS cidade, cj.nomeFantasia AS cliente
FROM clienteJuridico cj
RIGHT JOIN cliente cl ON cj.codCliente = cl.codCliente
RIGHT JOIN cidade c ON cl.codCidade = c.codCidade;