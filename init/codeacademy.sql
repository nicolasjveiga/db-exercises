SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

CREATE TABLE IF NOT EXISTS `departamento` (
  `codDepartamento` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(40) NOT NULL,
  `descricaoFuncional` varchar(80) DEFAULT NULL,
  `localizacao` mediumtext,
  PRIMARY KEY (`codDepartamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `estado` (
  `siglaEstado` varchar(2) NOT NULL,
  `nome` varchar(30) NOT NULL,
  PRIMARY KEY (`siglaEstado`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `cidade` (
  `codCidade` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) NOT NULL,
  `siglaEstado` varchar(2) NOT NULL,
  PRIMARY KEY (`codCidade`),
  UNIQUE KEY `nome` (`nome`),
  KEY `siglaEstado` (`siglaEstado`),
  CONSTRAINT `cidade_ibfk_1` FOREIGN KEY (`siglaEstado`) REFERENCES `estado` (`siglaEstado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `vendedor` (
  `codVendedor` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(60) NOT NULL,
  `dataNascimento` date DEFAULT NULL,
  `endereco` varchar(60) DEFAULT NULL,
  `cep` varchar(8) DEFAULT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `codCidade` int DEFAULT NULL,
  `dataContratacao` datetime DEFAULT CURRENT_TIMESTAMP,
  `codDepartamento` int DEFAULT NULL,
  PRIMARY KEY (`codVendedor`),
  KEY `codCidade` (`codCidade`),
  KEY `codDepartamento` (`codDepartamento`),
  CONSTRAINT `vendedor_ibfk_1` FOREIGN KEY (`codCidade`) REFERENCES `cidade` (`codCidade`),
  CONSTRAINT `vendedor_ibfk_2` FOREIGN KEY (`codDepartamento`) REFERENCES `departamento` (`codDepartamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `cliente` (
  `codCliente` int NOT NULL AUTO_INCREMENT,
  `endereco` varchar(60) DEFAULT NULL,
  `codCidade` int NOT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `tipo` char(1) DEFAULT NULL,
  `dataCadastro` datetime DEFAULT CURRENT_TIMESTAMP,
  `cep` char(8) DEFAULT NULL,
  PRIMARY KEY (`codCliente`),
  KEY `codCidade` (`codCidade`),
  CONSTRAINT `cliente_ibfk_1` FOREIGN KEY (`codCidade`) REFERENCES `cidade` (`codCidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `clienteFisico` (
  `codCliente` int NOT NULL,
  `nome` varchar(50) NOT NULL,
  `dataNascimento` date DEFAULT NULL,
  `cpf` char(11) NOT NULL,
  `rg` char(8) DEFAULT NULL,
  PRIMARY KEY (`codCliente`),
  UNIQUE KEY `cpf` (`cpf`),
  CONSTRAINT `clienteFisico_ibfk_1` FOREIGN KEY (`codCliente`) REFERENCES `cliente` (`codCliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `clienteJuridico` (
  `codCliente` int NOT NULL,
  `nomeFantasia` varchar(80) DEFAULT NULL,
  `razaoSocial` varchar(80) NOT NULL,
  `ie` varchar(20) NOT NULL,
  `cgc` varchar(20) NOT NULL,
  PRIMARY KEY (`codCliente`),
  UNIQUE KEY `razaoSocial` (`razaoSocial`),
  UNIQUE KEY `ie` (`ie`),
  UNIQUE KEY `cgc` (`cgc`),
  UNIQUE KEY `nomeFantasia` (`nomeFantasia`),
  CONSTRAINT `clienteJuridico_ibfk_1` FOREIGN KEY (`codCliente`) REFERENCES `cliente` (`codCliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `classe` (
  `codClasse` int NOT NULL AUTO_INCREMENT,
  `sigla` varchar(12) DEFAULT NULL,
  `nome` varchar(40) NOT NULL,
  `descricao` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`codClasse`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `produto` (
  `codProduto` int NOT NULL AUTO_INCREMENT,
  `descricao` varchar(40) NOT NULL,
  `unidadeMedida` char(2) DEFAULT NULL,
  `embalagem` varchar(15) DEFAULT 'Fardo',
  `codClasse` int DEFAULT NULL,
  `precoVenda` decimal(14,2) DEFAULT NULL,
  `estoqueMinimo` decimal(14,2) DEFAULT NULL,
  PRIMARY KEY (`codProduto`),
  KEY `codClasse` (`codClasse`),
  CONSTRAINT `produto_ibfk_1` FOREIGN KEY (`codClasse`) REFERENCES `classe` (`codClasse`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `produtoLote` (
  `codProduto` int NOT NULL,
  `numeroLote` int NOT NULL,
  `quantidadeAdquirida` decimal(14,2) DEFAULT NULL,
  `quantidadeVendida` decimal(14,2) DEFAULT NULL,
  `precoCusto` decimal(14,2) DEFAULT NULL,
  `validade` date DEFAULT NULL,
  PRIMARY KEY (`codProduto`,`numeroLote`),
  UNIQUE KEY `unique_numeroLote` (`numeroLote`),
  CONSTRAINT `produtoLote_ibfk_1` FOREIGN KEY (`codProduto`) REFERENCES `produto` (`codProduto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `venda` (
  `codVenda` int NOT NULL AUTO_INCREMENT,
  `codCliente` int NOT NULL,
  `codVendedor` int NOT NULL,
  `dataVenda` datetime DEFAULT CURRENT_TIMESTAMP,
  `enderecoEntrega` varchar(60) DEFAULT NULL,
  `statusVenda` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`codVenda`),
  KEY `codCliente` (`codCliente`),
  KEY `codVendedor` (`codVendedor`),
  CONSTRAINT `venda_ibfk_1` FOREIGN KEY (`codCliente`) REFERENCES `cliente` (`codCliente`),
  CONSTRAINT `venda_ibfk_2` FOREIGN KEY (`codVendedor`) REFERENCES `vendedor` (`codVendedor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `itemVenda` (
  `codVenda` int NOT NULL,
  `codProduto` int NOT NULL,
  `numeroLote` int NOT NULL,
  `quantidade` decimal(14,2) NOT NULL,
  PRIMARY KEY (`codVenda`,`codProduto`,`numeroLote`),
  KEY `codProduto` (`codProduto`,`numeroLote`),
  CONSTRAINT `itemVenda_ibfk_1` FOREIGN KEY (`codVenda`) REFERENCES `venda` (`codVenda`),
  CONSTRAINT `itemVenda_ibfk_2` FOREIGN KEY (`codProduto`,`numeroLote`) REFERENCES `produtoLote` (`codProduto`, `numeroLote`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `fornecedor` (
  `codFornecedor` int NOT NULL AUTO_INCREMENT,
  `nomeFantasia` varchar(80) DEFAULT NULL,
  `razaoSocial` varchar(80) NOT NULL,
  `ie` varchar(20) NOT NULL,
  `cgc` varchar(20) NOT NULL,
  `endereco` varchar(60) DEFAULT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `codCidade` int NOT NULL,
  PRIMARY KEY (`codFornecedor`),
  UNIQUE KEY `razaoSocial` (`razaoSocial`),
  UNIQUE KEY `ie` (`ie`),
  UNIQUE KEY `cgc` (`cgc`),
  UNIQUE KEY `nomeFantasia` (`nomeFantasia`),
  KEY `codCidade` (`codCidade`),
  CONSTRAINT `fornecedor_ibfk_1` FOREIGN KEY (`codCidade`) REFERENCES `cidade` (`codCidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `pedido` (
  `codPedido` int NOT NULL AUTO_INCREMENT,
  `dataRealizacao` datetime DEFAULT CURRENT_TIMESTAMP,
  `dataEntrega` date DEFAULT NULL,
  `codFornecedor` int DEFAULT NULL,
  `valor` decimal(20,2) DEFAULT NULL,
  PRIMARY KEY (`codPedido`),
  KEY `codFornecedor` (`codFornecedor`),
  CONSTRAINT `pedido_ibfk_1` FOREIGN KEY (`codFornecedor`) REFERENCES `fornecedor` (`codFornecedor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `itemPedido` (
  `codPedido` int NOT NULL,
  `codProduto` int NOT NULL,
  `quantidade` decimal(14,2) DEFAULT NULL,
  PRIMARY KEY (`codPedido`,`codProduto`),
  KEY `codProduto` (`codProduto`),
  CONSTRAINT `itemPedido_ibfk_1` FOREIGN KEY (`codPedido`) REFERENCES `pedido` (`codPedido`),
  CONSTRAINT `itemPedido_ibfk_2` FOREIGN KEY (`codProduto`) REFERENCES `produto` (`codProduto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `contasPagar` (
  `codTitulo` int NOT NULL AUTO_INCREMENT,
  `dataVencimento` date NOT NULL,
  `parcela` int DEFAULT NULL,
  `codPedido` int DEFAULT NULL,
  `valor` decimal(20,2) DEFAULT NULL,
  `dataPagamento` date DEFAULT NULL,
  `localPagamento` varchar(80) DEFAULT NULL,
  `juros` decimal(12,2) DEFAULT NULL,
  `correcaoMonetaria` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`codTitulo`),
  KEY `codPedido` (`codPedido`),
  CONSTRAINT `contasPagar_ibfk_1` FOREIGN KEY (`codPedido`) REFERENCES `pedido` (`codPedido`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `contasReceber` (
  `codTitulo` int NOT NULL AUTO_INCREMENT,
  `dataVencimento` date NOT NULL,
  `codVenda` int NOT NULL,
  `parcela` int DEFAULT NULL,
  `valor` decimal(20,2) DEFAULT NULL,
  `dataPagamento` date DEFAULT NULL,
  `localPagamento` varchar(80) DEFAULT NULL,
  `juros` decimal(12,2) DEFAULT NULL,
  `correcaoMonetaria` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`codTitulo`),
  KEY `codVenda` (`codVenda`),
  CONSTRAINT `contasReceber_ibfk_1` FOREIGN KEY (`codVenda`) REFERENCES `venda` (`codVenda`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

COMMIT;