USE exercicio2;

-- 1. Código, nome, endereço, nome da cidade, nome do estado dos vendedores cadastrados.
SELECT v.codVendedor, v.nome, v.endereco, c.nome AS cidade, e.nome AS estado
FROM vendedor v
JOIN cidade c ON v.codCidade = c.codCidade
JOIN estado e ON c.siglaEstado = e.siglaEstado;

-- 2. Código da venda, data de venda, nome do vendedor de todas as vendas com status de ‘Despachada’.
SELECT ve.codVenda, ve.dataVenda, v.nome
FROM venda ve
JOIN vendedor v ON ve.codVendedor = v.codVendedor
WHERE ve.statusVenda = 'Despachada';

-- 3. Clientes pessoa física que moram na Rua Marechal Floriano, 56.
SELECT cf.*
FROM clienteFisico cf
JOIN cliente c ON cf.codCliente = c.codCliente
WHERE c.endereco = 'Rua Marechal Floriano, 56';

-- 4. Todas as informações dos clientes que são pessoas jurídicas.
SELECT cj.*, c.*
FROM clienteJuridico cj
JOIN cliente c ON cj.codCliente = c.codCliente;

-- 5. Nome fantasia, endereço, telefone, nome da cidade, sigla do estado de todos os clientes jurídicos cadastrados entre 01/01/1999 e 30/06/2003.
SELECT cj.nomeFantasia, c.endereco, c.telefone, ci.nome AS cidade, ci.siglaEstado
FROM clienteJuridico cj
JOIN cliente c ON cj.codCliente = c.codCliente
JOIN cidade ci ON c.codCidade = ci.codCidade
WHERE c.dataCadastro BETWEEN '1999-01-01' AND '2003-06-30';

-- 6. Nome dos vendedores que realizaram vendas para o cliente pessoa jurídica com nome fantasia ‘TechRio’.
SELECT DISTINCT v.nome
FROM venda ve
JOIN vendedor v ON ve.codVendedor = v.codVendedor
JOIN clienteJuridico cj ON ve.codCliente = cj.codCliente
WHERE cj.nomeFantasia = 'TechRio';

-- 7. Código, número do lote e nome dos produtos que estão com a data de validade vencida.
SELECT pl.codProduto, pl.numeroLote, p.descricao
FROM produtoLote pl
JOIN produto p ON pl.codProduto = p.codProduto
WHERE pl.validade < CURDATE();

-- 8. Nome dos departamentos e nome dos vendedores neles lotados.
SELECT d.nome AS departamento, v.nome AS vendedor
FROM departamento d
JOIN vendedor v ON v.codDepartamento = d.codDepartamento;

-- 9. Código, nome e data de nascimento dos vendedores contratados após 2020.
SELECT codVendedor, nome, dataNascimento
FROM vendedor
WHERE dataContratacao > '2020-12-31';

-- 10. Nome dos produtos cujo estoque mínimo é maior que 100 unidades.
SELECT descricao
FROM produto
WHERE estoqueMinimo > 100;

-- 11. Nome e telefone dos clientes que possuem pelo menos uma venda registrada.
SELECT DISTINCT c.nome, c.telefone
FROM cliente c
JOIN venda v ON c.codCliente = v.codCliente;

-- 12. Nome dos fornecedores e a quantidade de pedidos realizados para cada um.
SELECT f.nomeFantasia, COUNT(p.codPedido) AS total_pedidos
FROM fornecedor f
LEFT JOIN pedido p ON f.codFornecedor = p.codFornecedor
GROUP BY f.codFornecedor;

-- 13. Nome dos clientes jurídicos que não possuem nenhum pedido registrado.
SELECT cj.nomeFantasia
FROM clienteJuridico cj
LEFT JOIN venda v ON cj.codCliente = v.codCliente
WHERE v.codVenda IS NULL;