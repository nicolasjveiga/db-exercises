CREATE DATABASE IF NOT EXISTS exercicio2;
USE exercicio2;

CREATE TABLE IF NOT EXISTS departamento (
  codDepartamento INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(40) NOT NULL,
  descricaoFuncional VARCHAR(80) DEFAULT NULL,
  localizacao MEDIUMTEXT,
  PRIMARY KEY (codDepartamento)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS estado (
  siglaEstado CHAR(2) NOT NULL,
  nome VARCHAR(30) NOT NULL,
  PRIMARY KEY (siglaEstado),
  UNIQUE KEY (nome)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS cidade (
  codCidade INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(50) NOT NULL UNIQUE,
  siglaEstado CHAR(2) NOT NULL,
  PRIMARY KEY (codCidade),
  CONSTRAINT fk_cidade_estado FOREIGN KEY (siglaEstado)
    REFERENCES estado(siglaEstado)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS vendedor (
  codVendedor INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(60) NOT NULL,
  dataNascimento DATE,
  endereco VARCHAR(60),
  cep CHAR(8),
  telefone VARCHAR(20),
  codCidade INT DEFAULT 1,
  dataContratacao DATE DEFAULT (CURRENT_DATE),
  codDepartamento INT,
  PRIMARY KEY (codVendedor),
  CONSTRAINT fk_vendedor_departamento FOREIGN KEY (codDepartamento)
    REFERENCES departamento(codDepartamento)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT fk_vendedor_cidade FOREIGN KEY (codCidade)
    REFERENCES cidade(codCidade)
    ON DELETE SET DEFAULT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS cliente (
  codCliente INT NOT NULL AUTO_INCREMENT,
  endereco VARCHAR(60),
  codCidade INT NOT NULL,
  telefone VARCHAR(20),
  tipo CHAR(1),
  dataCadastro DATE DEFAULT (CURRENT_DATE),
  cep CHAR(8),
  PRIMARY KEY (codCliente),
  CONSTRAINT fk_cli_cid FOREIGN KEY (codCidade)
    REFERENCES cidade(codCidade)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS clienteFisico (
  codCliente INT NOT NULL,
  nome VARCHAR(50) NOT NULL,
  dataNascimento DATE,
  cpf CHAR(11) NOT NULL UNIQUE,
  rg CHAR(8),
  PRIMARY KEY (codCliente),
  CONSTRAINT fk_clienteFisico_cliente FOREIGN KEY (codCliente)
    REFERENCES cliente(codCliente)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS clienteJuridico (
  codCliente INT NOT NULL,
  nomeFantasia VARCHAR(80) UNIQUE,
  razaoSocial VARCHAR(80) NOT NULL UNIQUE,
  ie VARCHAR(20) NOT NULL UNIQUE,
  cgc VARCHAR(20) NOT NULL UNIQUE,
  PRIMARY KEY (codCliente),
  CONSTRAINT fk_clienteJuridico_cliente FOREIGN KEY (codCliente)
    REFERENCES cliente(codCliente)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS classe (
  codClasse INT NOT NULL AUTO_INCREMENT,
  sigla VARCHAR(12),
  nome VARCHAR(40) NOT NULL,
  descricao VARCHAR(80),
  PRIMARY KEY (codClasse)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS produto (
  codProduto INT NOT NULL AUTO_INCREMENT,
  descricao VARCHAR(40) NOT NULL,
  unidadeMedida CHAR(2),
  embalagem VARCHAR(15) DEFAULT 'Fardo',
  codClasse INT,
  precoVenda DECIMAL(14,2),
  estoqueMinimo DECIMAL(14,2),
  PRIMARY KEY (codProduto),
  CONSTRAINT fk_produto_classe FOREIGN KEY (codClasse)
    REFERENCES classe(codClasse)
    ON DELETE SET NULL
    ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS produtoLote (
  codProduto INT NOT NULL,
  numeroLote INT NOT NULL,
  quantidadeAdquirida DECIMAL(14,2),
  quantidadeVendida DECIMAL(14,2),
  precoCusto DECIMAL(14,2),
  validade DATE,
  PRIMARY KEY (codProduto, numeroLote),
  CONSTRAINT fk_produtoLote_produto FOREIGN KEY (codProduto)
    REFERENCES produto(codProduto)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS venda (
  codVenda INT NOT NULL AUTO_INCREMENT,
  codCliente INT NOT NULL,
  codVendedor INT NOT NULL DEFAULT 100,
  dataVenda DATE DEFAULT (CURRENT_DATE),
  enderecoEntrega VARCHAR(60),
  statusVenda VARCHAR(30),
  PRIMARY KEY (codVenda),
  CONSTRAINT fk_venda_cliente FOREIGN KEY (codCliente)
    REFERENCES cliente(codCliente)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT fk_venda_vendedor FOREIGN KEY (codVendedor)
    REFERENCES vendedor(codVendedor)
    ON DELETE SET DEFAULT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS itemVenda (
  codVenda INT NOT NULL,
  codProduto INT NOT NULL,
  numeroLote INT NOT NULL,
  quantidade DECIMAL(14,2) NOT NULL CHECK (quantidade > 0),
  PRIMARY KEY (codVenda, codProduto, numeroLote),
  CONSTRAINT fk_itemVenda_venda FOREIGN KEY (codVenda)
    REFERENCES venda(codVenda)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_itemVenda_produtoLote FOREIGN KEY (codProduto, numeroLote)
    REFERENCES produtoLote(codProduto, numeroLote)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS fornecedor (
  codFornecedor INT NOT NULL AUTO_INCREMENT,
  nomeFantasia VARCHAR(80) UNIQUE,
  razaoSocial VARCHAR(80) NOT NULL UNIQUE,
  ie VARCHAR(20) NOT NULL UNIQUE,
  cgc VARCHAR(20) NOT NULL UNIQUE,
  endereco VARCHAR(60),
  telefone VARCHAR(20),
  codCidade INT NOT NULL,
  PRIMARY KEY (codFornecedor),
  CONSTRAINT fk_fornecedor_cidade FOREIGN KEY (codCidade)
    REFERENCES cidade(codCidade)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS pedido (
  codPedido INT NOT NULL AUTO_INCREMENT,
  dataRealizacao DATE DEFAULT (CURRENT_DATE),
  dataEntrega DATE,
  codFornecedor INT,
  valor DECIMAL(20,2),
  PRIMARY KEY (codPedido),
  CONSTRAINT fk_pedido_fornecedor FOREIGN KEY (codFornecedor)
    REFERENCES fornecedor(codFornecedor)
    ON DELETE CASCADE
    ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS itemPedido (
  codPedido INT NOT NULL,
  codProduto INT NOT NULL,
  quantidade DECIMAL(14,2) NOT NULL CHECK (quantidade > 0),
  PRIMARY KEY (codPedido, codProduto),
  CONSTRAINT fk_itemPedido_pedido FOREIGN KEY (codPedido)
    REFERENCES pedido(codPedido)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_itemPedido_produto FOREIGN KEY (codProduto)
    REFERENCES produto(codProduto)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS contasPagar (
  codTitulo INT NOT NULL AUTO_INCREMENT,
  dataVencimento DATE NOT NULL,
  parcela INT,
  codPedido INT,
  valor DECIMAL(20,2),
  dataPagamento DATE,
  localPagamento VARCHAR(80),
  juros DECIMAL(12,2),
  correcaoMonetaria DECIMAL(12,2),
  PRIMARY KEY (codTitulo),
  CONSTRAINT fk_contasPagar_pedido FOREIGN KEY (codPedido)
    REFERENCES pedido(codPedido)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS contasReceber (
  codTitulo INT NOT NULL AUTO_INCREMENT,
  dataVencimento DATE NOT NULL,
  codVenda INT NOT NULL,
  parcela INT,
  valor DECIMAL(20,2),
  dataPagamento DATE,
  localPagamento VARCHAR(80),
  juros DECIMAL(12,2),
  correcaoMonetaria DECIMAL(12,2),
  PRIMARY KEY (codTitulo),
  CONSTRAINT fk_contasReceber_venda FOREIGN KEY (codVenda)
    REFERENCES venda(codVenda)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO departamento (nome, descricaoFuncional, localizacao) VALUES
  ('Comercial', 'Depto Comercial', 'Térreo'),
  ('TI', 'Tecnologia da Informação', '3º Andar');

INSERT INTO estado (siglaEstado, nome) VALUES
  ('SP', 'São Paulo'),
  ('RJ', 'Rio de Janeiro');

INSERT INTO cidade (nome, siglaEstado) VALUES
  ('São Paulo', 'SP'),
  ('Niterói', 'RJ');

INSERT INTO vendedor (nome, dataNascimento, endereco, cep, telefone, codCidade, dataContratacao, codDepartamento) VALUES
  ('Marcos Lima', '1982-07-15', 'Av. Paulista, 1000', '01310000', '11999990000', 1, '2022-02-01', 1),
  ('Fernanda Dias', '1995-11-30', 'Rua das Laranjeiras, 50', '22240000', '21988887777', 2, '2021-03-10', 2);

INSERT INTO cliente (endereco, codCidade, telefone, tipo, dataCadastro, cep) VALUES
  ('Rua Marechal Floriano, 56', 1, '11977776666', 'F', '2001-04-10', '01311000'),
  ('Rua do Comércio, 200', 2, '21966665555', 'J', '2002-02-20', '22241000');

INSERT INTO clienteFisico (codCliente, nome, dataNascimento, cpf, rg) VALUES
  (1, 'Paulo Roberto', '1975-05-20', '11122233344', 'SP1234567');

INSERT INTO clienteJuridico (codCliente, nomeFantasia, razaoSocial, ie, cgc) VALUES
  (2, 'TechRio', 'TechRio Soluções LTDA', 'RJ987654', '98765432000100');

INSERT INTO classe (sigla, nome, descricao) VALUES
  ('B', 'Bebidas', 'Bebidas em geral');

INSERT INTO produto (descricao, unidadeMedida, embalagem, codClasse, precoVenda, estoqueMinimo) VALUES
  ('Refrigerante', 'LT', 'Caixa', 1, 6.50, 80),
  ('Água Mineral', 'LT', 'Caixa', 1, 3.00, 200);

INSERT INTO produtoLote (codProduto, numeroLote, quantidadeAdquirida, quantidadeVendida, precoCusto, validade) VALUES
  (1, 201, 50, 40, 4.00, '2022-12-31'),
  (2, 202, 300, 100, 2.00, '2026-05-01');

INSERT INTO venda (codCliente, codVendedor, dataVenda, enderecoEntrega, statusVenda) VALUES
  (2, 1, '2023-08-15', 'Rua do Comércio, 200', 'Despachada'),
  (1, 2, '2024-02-10', 'Rua Marechal Floriano, 56', 'Pendente');

INSERT INTO itemVenda (codVenda, codProduto, numeroLote, quantidade) VALUES
  (1, 1, 201, 5),
  (2, 2, 202, 10);

INSERT INTO fornecedor (nomeFantasia, razaoSocial, ie, cgc, endereco, telefone, codCidade) VALUES
  ('Fornecedora SP', 'Fornecedora SP LTDA', 'SP876543', '12312312000199', 'Rua do Fornecedor, 1', '11955554444', 1);

INSERT INTO pedido (dataRealizacao, dataEntrega, codFornecedor, valor) VALUES
  ('2024-03-01', '2024-03-10', 1, 1000.00);

INSERT INTO itemPedido (codPedido, codProduto, quantidade) VALUES
  (1, 1, 15);

INSERT INTO contasPagar (dataVencimento, parcela, codPedido, valor, dataPagamento, localPagamento, juros, correcaoMonetaria) VALUES
  ('2024-04-01', 1, 1, 1000.00, NULL, NULL, 0, 0);

INSERT INTO contasReceber (dataVencimento, codVenda, parcela, valor, dataPagamento, localPagamento, juros, correcaoMonetaria) VALUES
  ('2023-09-01', 1, 1, 300.00, NULL, NULL, 0, 0);

-- 1. Pedido de 2014 para o NATURAL JOIN com fornecedor
INSERT INTO fornecedor (nomeFantasia, razaoSocial, ie, cgc, endereco, telefone, codCidade)
VALUES ('Incepa', 'Incepa LTDA', 'PR123456', '12345678000111', 'Rua Incepa, 100', '41988887777', 1)
ON DUPLICATE KEY UPDATE nomeFantasia=nomeFantasia;

INSERT INTO pedido (dataRealizacao, dataEntrega, codFornecedor, valor)
VALUES ('2014-06-15', '2014-06-20', (SELECT codFornecedor FROM fornecedor WHERE nomeFantasia='Incepa'), 500.00);

-- 2. Cidade 'Apucarana' e vendedor nela
INSERT INTO estado (siglaEstado, nome) VALUES ('PR', 'Paraná')
ON DUPLICATE KEY UPDATE nome=nome;
INSERT INTO cidade (nome, siglaEstado) VALUES ('Apucarana', 'PR')
ON DUPLICATE KEY UPDATE nome=nome;
INSERT INTO vendedor (nome, dataNascimento, endereco, cep, telefone, codCidade, dataContratacao, codDepartamento)
VALUES ('Joana Apucarana', '1992-10-10', 'Rua Central, 10', '86800000', '43999990000', (SELECT codCidade FROM cidade WHERE nome='Apucarana'), '2023-01-01', 1);

-- 3. Produto 'Cal', classe 'Acabamentos', lote, venda e itemVenda
INSERT INTO classe (sigla, nome, descricao) VALUES ('C', 'Acabamentos', 'Produtos de acabamento')
ON DUPLICATE KEY UPDATE nome=nome;
INSERT INTO produto (descricao, unidadeMedida, embalagem, codClasse, precoVenda, estoqueMinimo)
VALUES ('Cal', 'KG', 'Saco', (SELECT codClasse FROM classe WHERE nome='Acabamentos'), 15.00, 30)
ON DUPLICATE KEY UPDATE descricao=descricao;
INSERT INTO produtoLote (codProduto, numeroLote, quantidadeAdquirida, quantidadeVendida, precoCusto, validade)
VALUES ((SELECT codProduto FROM produto WHERE descricao='Cal'), 301, 100, 10, 10.00, '2025-12-31')
ON DUPLICATE KEY UPDATE quantidadeAdquirida=quantidadeAdquirida;
INSERT INTO venda (codCliente, codVendedor, dataVenda, enderecoEntrega, statusVenda)
VALUES (1, 1, '2024-05-01', 'Rua Marechal Floriano, 56', 'Despachada');
INSERT INTO itemVenda (codVenda, codProduto, numeroLote, quantidade)
VALUES (
  (SELECT codVenda FROM venda ORDER BY codVenda DESC LIMIT 1),
  (SELECT codProduto FROM produto WHERE descricao='Cal'),
  301,
  2
);

-- 4. Produto da classe 'Acabamentos' já inserido acima ('Cal')

-- 5. Pedido do fornecedor 'Incepa' já inserido acima

-- 6. Produto sem venda (para LEFT JOIN)
INSERT INTO produto (descricao, unidadeMedida, embalagem, codClasse, precoVenda, estoqueMinimo)
VALUES ('Tinta', 'LT', 'Lata', (SELECT codClasse FROM classe LIMIT 1), 50.00, 10)
ON DUPLICATE KEY UPDATE descricao=descricao;

-- 7. Fornecedor sem pedido (para LEFT JOIN)
INSERT INTO fornecedor (nomeFantasia, razaoSocial, ie, cgc, endereco, telefone, codCidade)
VALUES ('FornecedorSemPedido', 'Fornecedor Sem Pedido LTDA', 'SP000000', '00000000000100', 'Rua Zero, 0', '1100000000', 1)
ON DUPLICATE KEY UPDATE nomeFantasia=nomeFantasia;

-- 8. Departamento sem vendedor (para RIGHT JOIN)
INSERT INTO departamento (nome, descricaoFuncional, localizacao)
VALUES ('SemVendedor', 'Departamento vazio', 'Subsolo')
ON DUPLICATE KEY UPDATE nome=nome;

-- 9. Cliente sem venda (para RIGHT JOIN/UNION)
INSERT INTO cliente (endereco, codCidade, telefone, tipo, dataCadastro, cep)
VALUES ('Rua SemVenda, 1', 1, '1100000000', 'F', '2022-01-01', '00000000');
INSERT INTO clienteFisico (codCliente, nome, dataNascimento, cpf, rg)
VALUES (LAST_INSERT_ID(), 'Cliente Sem Venda', '1990-01-01', '99999999999', 'RG999999');

-- 10. Classe sem produto (para LEFT JOIN)
INSERT INTO classe (sigla, nome, descricao) VALUES ('D', 'SemProduto', 'Classe sem produto')
ON DUPLICATE KEY UPDATE nome=nome;

-- 11. Estado sem cidade (para RIGHT JOIN)
INSERT INTO estado (siglaEstado, nome) VALUES ('ES', 'Espírito Santo')
ON DUPLICATE KEY UPDATE nome=nome;

-- 12. Produto sem lote (para LEFT JOIN)
INSERT INTO produto (descricao, unidadeMedida, embalagem, codClasse, precoVenda, estoqueMinimo)
VALUES ('Cimento', 'KG', 'Saco', (SELECT codClasse FROM classe LIMIT 1), 25.00, 20)
ON DUPLICATE KEY UPDATE descricao=descricao;

-- 13. Cidade sem vendedor (para RIGHT JOIN)
INSERT INTO cidade (nome, siglaEstado) VALUES ('CidadeSemVendedor', 'ES')
ON DUPLICATE KEY UPDATE nome=nome;

-- 14. Cidade sem cliente (para RIGHT JOIN)
INSERT INTO cidade (nome, siglaEstado) VALUES ('CidadeSemCliente', 'ES')
ON DUPLICATE KEY UPDATE nome=nome;

-- 15. Cliente jurídico sem venda (para RIGHT JOIN/UNION)
INSERT INTO cliente (endereco, codCidade, telefone, tipo, dataCadastro, cep)
VALUES ('Rua Empresarial, 500', (SELECT codCidade FROM cidade WHERE nome='CidadeSemCliente'), '34999990000', 'J', '2022-01-01', '38000000');
INSERT INTO clienteJuridico (codCliente, nomeFantasia, razaoSocial, ie, cgc)
VALUES (LAST_INSERT_ID(), 'EmpreUber', 'EmpreUber LTDA', 'MG123456', '12345678000222');

COMMIT;