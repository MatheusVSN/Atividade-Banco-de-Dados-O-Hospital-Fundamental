-- Criação da databse do hospital caso não existente
CREATE DATABASE IF NOT EXISTS HOSPITAL_DATABASE;
USE HOSPITAL_DATABASE;

-- Especialização do médico
CREATE TABLE IF NOT EXISTS especialidades(
	`especialidade_id` INT(100) AUTO_INCREMENT PRIMARY KEY,
    `especialidade_nome` VARCHAR(100)
);

-- Convênios
CREATE TABLE IF NOT EXISTS convenio(
	`convenio_id` INT(100) AUTO_INCREMENT PRIMARY KEY,
    `convenio_nome` VARCHAR(100),
    `convenio_cnpj` VARCHAR(15),
    `convenio_tempo_carecia` VARCHAR(100)
);

-- Informações do médico
CREATE TABLE IF NOT EXISTS medico(
	`medico_id` INT(100) PRIMARY KEY AUTO_INCREMENT,
    `medico_nome` VARCHAR(150) NOT NULL,
    `medico_email` VARCHAR(256) NOT NULL,
    `medico_cpf` INT(15) UNIQUE NOT NULL,
    `medico_crm` VARCHAR(15) UNIQUE NOT NULL,
    `medico_cargo` VARCHAR(100) NOT NULL,
    `medico_especialidade` INT(100) NOT NULL,
    CONSTRAINT `medico_especialidade` FOREIGN KEY (`medico_especialidade`) REFERENCES `especialidades`(`especialidade_id`) ON UPDATE CASCADE
);

-- Receita
CREATE TABLE IF NOT EXISTS receita(
	`receita_id` INT(100) AUTO_INCREMENT PRIMARY KEY,
    `receita_medicamentos` VARCHAR(200),
    `receita_quantidade_medicamentos` INT(100),
    `receita_instrucoes_uso` VARCHAR(100),
    `receita_requer_internacao` BOOLEAN NOT NULL
);

-- Tipo de quarto
CREATE TABLE IF NOT EXISTS tipoQuarto(
	`tipo_id` INT(100) AUTO_INCREMENT PRIMARY KEY,
    `tipo_descricao` VARCHAR(200),
    `tipo_valor_diaria` DECIMAL NOT NULL
);

-- Quarto
CREATE TABLE IF NOT EXISTS quarto(
	`quarto_id` INT(100) AUTO_INCREMENT PRIMARY KEY,
    `quarto_numero` INT(100) NOT NULL,
    `quarto_tipo` INT(100) NOT NULL,
    
    CONSTRAINT `quarto_tipo` FOREIGN KEY (`quarto_tipo`) REFERENCES `tipoQuarto`(`tipo_id`) ON UPDATE CASCADE
);

-- Informações do enfermeiro
CREATE TABLE IF NOT EXISTS enfermeiro(
	`enfermeiro_id` INT(100) PRIMARY KEY AUTO_INCREMENT,
    `enfermeiro_nome` INT(150) NOT NULL,
    `enferemeiro_cpf` INT(15) UNIQUE NOT NULL,
    `enfermeiro_cre` VARCHAR(15) UNIQUE NOT NULL
);

-- Informações do paciente
CREATE TABLE IF NOT EXISTS paciente(
	`paciente_id` INT(100) PRIMARY KEY AUTO_INCREMENT,
    `paciente_nome` VARCHAR(150) NOT NULL,
    `paciente_nascimento` DATE NOT NULL,
    `paciente_endereco` VARCHAR(200) NOT NULL,
    `paciente_telefone` INT(20) NOT NULL,
    `paciente_email` VARCHAR(256) NOT NULL,
    `paciente_rg` VARCHAR(12) UNIQUE NOT NULL,
    `paciente_cpf` INT(15) UNIQUE NOT NULL,
    `paciente_convenio` INT(100) NOT NULL,
    CONSTRAINT `paciente_convenio` FOREIGN KEY (`paciente_convenio`) REFERENCES `convenio`(`convenio_id`) ON UPDATE CASCADE
);

-- Internacao
CREATE TABLE IF NOT EXISTS internacao(
	`internacao_id` INT(100) AUTO_INCREMENT PRIMARY KEY,
    `internacao_data_entrada` DATE NOT NULL,
    `internacao_data_prevista_alta` DATE NOT NULL,
    `internacao_data_efetiva_alta` DATE NOT NULL,
    `internacao_procedimento` VARCHAR(200),
    `paciente_id` INT(100) NOT NULL,
    `medico_id` INT(100) NOT NULL,
    `enfermeiro_id` INT(100) NOT NULL,
    `quarto_id` INT(100) NOT NULL,
    CONSTRAINT `paciente_id` FOREIGN KEY (`paciente_id`) REFERENCES `paciente`(`paciente_id`) ON UPDATE CASCADE,
    CONSTRAINT `medico_id` FOREIGN KEY (`medico_id`) REFERENCES `medico`(`medico_id`) ON UPDATE CASCADE,
    CONSTRAINT `enfermeiro_id` FOREIGN KEY (`enfermeiro_id`) REFERENCES `enfermeiro`(`enfermeiro_id`) ON UPDATE CASCADE,
    CONSTRAINT `quarto_id` FOREIGN KEY (`quarto_id`) REFERENCES `quarto`(`quarto_id`) ON UPDATE CASCADE
);

-- Informações da consulta
CREATE TABLE IF NOT EXISTS consulta(
	`consulta_id` INT(100) PRIMARY KEY AUTO_INCREMENT,
    `consulta_data` DATE NOT NULL,
    `consulta_hora` TIME NOT NULL,
    `consulta_medico` INT(100) NOT NULL,
    `consulta_valor` DECIMAL,
    `consulta_especialidade` INT(100) NOT NULL,
    `consulta_receita` INT(100) NOT NULL,
    `consulta_convenio` INT(100) NOT NULL,
    
    CONSTRAINT `consulta_medico` FOREIGN KEY (`consulta_medico`) REFERENCES `medico`(`medico_id`) ON UPDATE CASCADE,
    CONSTRAINT `consulta_especialidade` FOREIGN KEY (`consulta_especialidade`) REFERENCES `especialidades`(`especialidade_id`) ON UPDATE CASCADE,
    CONSTRAINT `consulta_receita` FOREIGN KEY (`consulta_receita`) REFERENCES `receita`(`receita_id`) ON UPDATE CASCADE,
    CONSTRAINT `consulta_convenio` FOREIGN KEY (`consulta_convenio`) REFERENCES `convenio`(`convenio_id`) ON UPDATE CASCADE
);

-- Relatório
CREATE TABLE IF NOT EXISTS relatorio(
	`impressao_id` INT(100) PRIMARY KEY AUTO_INCREMENT,
    `paciente` INT(100) NOT NULL,
    `medico` INT(100) NOT NULL,
    
    CONSTRAINT `paciente` FOREIGN KEY (`paciente`) REFERENCES `paciente`(`paciente_id`) ON UPDATE CASCADE,
    CONSTRAINT `medico` FOREIGN KEY (`medico`) REFERENCES `medico`(`medico_id`) ON UPDATE CASCADE
);