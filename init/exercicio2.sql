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

COMMIT;