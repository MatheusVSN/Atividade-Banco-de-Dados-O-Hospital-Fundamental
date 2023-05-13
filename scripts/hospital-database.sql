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
    `paciente_rg` INT(12) UNIQUE NOT NULL,
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
    `internacao_paciente_id` INT(100) NOT NULL,
    `internacao_medico_id` INT(100) NOT NULL,
    `internacao_enfermeiro_id` INT(100) NOT NULL,
    `internacao_quarto_id` INT(100) NOT NULL,
    CONSTRAINT `internacao_paciente_id` FOREIGN KEY (`paciente_id`) REFERENCES `paciente`(`paciente_id`) ON UPDATE CASCADE,
    CONSTRAINT `internacao_internacao_medico_id` FOREIGN KEY (`medico_id`) REFERENCES `medico`(`medico_id`) ON UPDATE CASCADE,
    CONSTRAINT `internacao_enfermeiro_id` FOREIGN KEY (`enfermeiro_id`) REFERENCES `enfermeiro`(`enfermeiro_id`) ON UPDATE CASCADE,
    CONSTRAINT `internacao_quarto_id` FOREIGN KEY (`quarto_id`) REFERENCES `quarto`(`quarto_id`) ON UPDATE CASCADE
);

-- Enfermeiro relacionado a internação
CREATE TABLE IF NOT EXISTS enfermeiro_internacao(
    `enfermeiro_id` INT(100) NOT NULL,
    `internacao_id` INT(100) NOT NULL,
    CONSTRAINT `enfermeiro_id` FOREIGN KEY (`enfermeiro_id`) REFERENCES `enfermeiro`(`enfermeiro_id`) ON UPDATE CASCADE,
    CONSTRAINT `internacao_id` FOREIGN KEY (`internacao_id`) REFERENCES `internacao`(`internacao_id`) ON UPDATE CASCADE
);

-- Informações da consulta
CREATE TABLE IF NOT EXISTS consulta(
	`consulta_id` INT(100) PRIMARY KEY AUTO_INCREMENT,
    `consulta_data` DATE NOT NULL,
    `consulta_hora` TIME NOT NULL,
    `consula_paciente` INT(100) NOT NULL,
    `consulta_medico` INT(100) NOT NULL,
    `consulta_valor` DECIMAL,
    `consulta_especialidade` INT(100) NOT NULL,
    `consulta_receita` INT(100) NOT NULL,
    `consulta_convenio` INT(100) NOT NULL,
    
    CONSTRAINT `consulta_medico` FOREIGN KEY (`consulta_medico`) REFERENCES `medico`(`medico_id`) ON UPDATE CASCADE,
    CONSTRAINT `consulta_especialidade` FOREIGN KEY (`consulta_especialidade`) REFERENCES `especialidades`(`especialidade_id`) ON UPDATE CASCADE,
    CONSTRAINT `consulta_receita` FOREIGN KEY (`consulta_receita`) REFERENCES `receita`(`receita_id`) ON UPDATE CASCADE,
    CONSTRAINT `consulta_convenio` FOREIGN KEY (`consulta_convenio`) REFERENCES `convenio`(`convenio_id`) ON UPDATE CASCADE,
    CONSTRAINT `consulta_paciente` FOREIGN KEY (`consulta_paciente`) REFERENCES `paciente`(`paciente_id`) ON UPDATE CASCADE
);

-- Relatório
CREATE TABLE IF NOT EXISTS relatorio(
	`impressao_id` INT(100) PRIMARY KEY AUTO_INCREMENT,
    `paciente` INT(100) NOT NULL,
    `medico` INT(100) NOT NULL,
    
    CONSTRAINT `paciente` FOREIGN KEY (`paciente`) REFERENCES `paciente`(`paciente_id`) ON UPDATE CASCADE,
    CONSTRAINT `medico` FOREIGN KEY (`medico`) REFERENCES `medico`(`medico_id`) ON UPDATE CASCADE
);

-- Adicionando covnenios
INSERT INTO convenio (convenio_nome, convenio_cnpj, convenio_tempo_carencia) VALUES
("Amil", 26444382000103, "24 Horas"),
("SulAmerica", 61838312000100, "30 Dias"),
("Bradesco Saude", 92680457000177, "180 Dias"),
("Unimed", 5910960900013, "2 Anos");

-- Aidicionando Especialidades
INSERT INTO especialidades (especialidade_nome) VALUES
("Pediatria"), 
("Clínica Geral"), 
("Gastrenterologia"), 
("Dermatologia"), 
("Psiquiatria"), 
("Ortopedia"), 
("Endocrinologia"), 
("Neurologia"), 
("Oncologia"), 
("Oftalmologia");

-- Adicionando médicos
INSERT INTO medico (medico_nome, medico_email, medico_cpf, medico_crm, medico_cargo, medico_especialidade) VALUES
("João Silva", "joao.silva@gmail.com", "111.222.333-44", "CRM-SP 12345", "Médico", 1),
("Pedro Santos", "pedro.santos@gmail.com", "111.222.333-45", "CRM-SP 23456", "Médico", 2),
("Maria Oliveira", "maria.oliveira@gmail.com", "111.222.333-46", "CRM-SP 34567", "Médico", 3),
("Roberto Costa", "roberto.costa@gmail.com", "111.222.333-47", "CRM-SP 45678", "Médico", 4),
("Amanda Ferreira", "amanda.ferreira@gmail.com", "111.222.333-48", "CRM-SP 56789", "Médico", 5),
("Lucas Souza", "lucas.souza@gmail.com", "111.222.333-49", "CRM-SP 67890", "Médico", 6),
("Carla Santos", "carla.santos@gmail.com", "111.222.333-50", "CRM-SP 78901", "Médico", 7),
("Julia Lima", "julia.lima@gmail.com", "111.222.333-51", "CRM-SP 89012", "Médico", 8),
("Rodrigo Almeida", "rodrigo.almeida@gmail.com", "111.222.333-52", "CRM-SP 90123", "Médico", 9),
("Luana Santos", "luana.santos@gmail.com", "111.222.333-53", "CRM-SP 01234", "Médico", 10);

-- Adicionando pacientes
INSERT INTO paciente (paciente_nome, paciente_nascimento, paciente_endereco, paciente_telefone, paciente_email, paciente_rg, paciente_cpf, paciente_convenio) VALUES
("Luísa Alves", "15-05-1982", "Rua José",11999998888, "luisa.alves@email.com", 55667788, 12345678900, 1),
("Pedro Henrique", "10-02-1975", "Avenida Brasil", 11987654321, "pedro.henrique@email.com", 11223344, 98765432111, 2),
("Ana Carolina", "20-07-1990", "Rua João Pessoa", 11333333333, "ana.caronlina@email.com", 44556677, 23456789022, 3),
("Lucas Mendes", "05-11-1988", "Rua General Glicério", 11777777777, "lucas.mendes@email.com", 88776655, 34567890133, 4),
("Mariana Ferreira", "02-09-1995", "Avenida Paulista", 1177778888, "mariana.ferreira@email.com", 77889900, 45678901244, 1),
("Guilherme Souza", "18-04-1980", "Rua do Rosário", 1155554444, "guilherme.souza@email.com", 33445566, 56789012355, 2),
("Fernanda Costa", "30-12-1985", "Avenida Rio Branco", 1166665555, "fernanda.costa@email.com", 22113344, 67890123466, 3),
("Bruno Santos", "25-06-1992", "Rua XV de Novembro", 1122221111, "bruno.santos@email.com", 55443322, 78901234577, 4),
("Marina Costa", "17-09-1987", "Rua Barão", 1133332222, "marina.costa@email.com", 88997766, 89012345688, 1),
("André Luiz", "01-02-1981", "Rua da Consolação", 1133334444, "andre.luiz@email.com", 11001122, 90123456799, 2),
("Camila Pereira", "19-06-1998", "Rua das Flores", 1144443333, "camila.pereira@email.com", 77665544, 1234567810, 3),
("Eduardo Santos", "07-03-1977", "Avenida Atlântica", 1122223333, "eduardo.santos@email.com", 66554433, 12345678901, 4),
("Juliana Ferreira", "13-12-1993", "Rua Major", 1144445555, "juliana.ferreira@email.com", 99887766, 234567890, 1),
("Rafaela Oliveira", "09-07-1991", "Rua Joaquim", 11977776666, "rafaela.oliveira@email.com", 99887766, 34567890123, 2),
("Gustavo Silva", "03-05-1986", "Avenida Rebouças", 1122223333, "gustavo.silva@email.com", 77665544, 45678901234, 3);

-- Inserindo Receitas
INSERT INTO receita (receita_medicamentos, receita_quantidade_medicamentos, receita_instrucoes_uso) VALUES
("Paracetamol", "500mg",  "1 comprimido de 6 em 6 horas durante 3 dias"),
("Dipirona", "500mg", "1 comprimido de 8 em 8 horas durante 2 dias"),
("Ibuprofeno", "400mg", "1 comprimido de 12 em 12 horas durante 5 dias"),
("Amoxicilina", "500mg", "1 comprimido de 8 em 8 horas durante 7 dias"),
("Omeprazol", "20mg", "1 comprimido de 12 em 12 horas durante 14 dias"),
("Diclofenaco", "50mg", "1 comprimido de 8 em 8 horas durante 3 dias"),
("Azitromicina", "500mg", "1 comprimido ao dia durante 5 dias"),
("Rivotril",  "2mg", "1 comprimido à noite antes de dormir"),
("Paroxetina ", "20mg", "1 comprimido de manhã após o café"),
("Sinvastatina",  "20mg", "1 comprimido à noite antes de dormir"),
("Losartana",  "50mg", "1 comprimido ao dia"),
("Captopril",  "25mg", "1 comprimido de 12 em 12 horas durante 7 dias"),
("Atenolol 25mg",  "1 comprimido ao dia"),
("Hidroclorotiazida", "25mg",  "1 comprimido ao dia"),
("Metformina", "500mg",  "1 comprimido de manhã e 1 comprimido à noite após as refeições"),
("Insulina", "Regular",  "aplicar 10 unidades antes das refeições"),
("Insulina", "NPH",  "aplicar 10 unidades à noite antes de dormir"),
("Levotiroxina","50mcg", "1 comprimido de manhã em jejum"),
("Clonazepam", "2mg", "1 comprimido antes de dormir"),
("Dexametasona", "4mg", "1 comprimido de manhã após o café durante 5 dias");

-- Inserindo Consultas
INSERT INTO consulta (consulta_data, consulta_hora, consulta_medico, consulta_valor, consulta_especialidade, consulta_receita, consulta_convenio, consulta_paciente) VALUES
    ('01-01-2015', '10:00:00', 1, 150, 1, 1, 1, 1),
    ('01-02-2015', '11:00:00', 2, 150, 2, 2, 2, 2),
    ('01-03-2015', '12:00:00', 3, 200, 3, 3, 3, 3),
    ('01-03-2015', '13:00:00', 4, 200, 4, 4, 4, 4),
    ('01-05-2015', '14:00:00', 5, 250, 5, 5, 1, 5),
    ('01-06-2015', '15:00:00', 6, 250, 6, 6, 2, 6),
    ('01-08-2015', '16:00:00', 7, 300, 7,7, 3, 7),
    ('01-08-2015', '17:00:00', 8, 300, 8, 8, 4, 8),
    ('01-09-2015', '18:00:00', 9, 350, 9, 9, 1, 9),
    ('01-10-2015', '19:00:00', 10, 350, 10, 10, 2, 10),
    ('01-01-2016', '10:00:00', 1, 150, 1, 11, 3, 11),
    ('01-02-2016', '11:00:00', 2, 150, 2, 12, 4, 12),
    ('01-03-2016', '12:00:00', 3, 200, 3, 13, 1, 13),
    ('01-03-2016', '13:00:00', 4, 200, 4, 14, 2, 14),
    ('01-05-2016', '14:00:00', 5, 250, 5, 15, 3, 15),
    ('01-06-2016', '15:00:00', 6, 250, 6, 16, 4, 1),
    ('01-08-2016', '16:00:00', 7, 300, 7, 17, 1, 2),
    ('08-01-2016', '17:00:00', 8, 300, 8, 18, 2, 3),
    ('01-09-2016', '18:00:00', 9, 350, 9, 19, 3, 4),
    ('01-10-2016', '19:00:00', 10, 350, 10, 20, 4, 5);

-- Inserindo Internações
INSERT INTO internacao (internacao_data_entrada, internacao_data_prevista_alta, internacao_data_efetiva_alta, internacao_procedimento, internacao_paciente_id, internacao_medico_id, internacao_enfermeiro_id, internacao_quarto_id) VALUES 
('2015-03-12', '2015-03-18', '2015-03-20', 'Cirurgia de emergência', 1, 3, 1, 1),
('2016-05-07', '2016-05-12', '2016-05-14', 'Cirurgia de emergência', 2, 4, 2, 2),
('2016-09-21', '2016-10-03', '2016-10-04', 'Cirurgia de emergência', 3, 1, 3, 3),
('2017-06-11', '2017-06-18', '2017-06-21', 'Cirurgia de emergência', 4, 2, 4, 2),
('2018-01-15', '2018-01-20', '2018-01-22', 'Cirurgia de emergência', 5, 3, 5, 1),
('2018-05-02', '2018-05-09', '2018-05-11', 'Cirurgia de emergência', 2, 4, 6, 3),
('2021-08-10', '2021-08-17', '2021-08-18', 'Cirurgia eletiva', 6, 1, 7, 2),
('2022-01-01', '2022-01-07', NULL, 'Cirurgia eletiva', 7, 2, 8, 3),
('2016-03-27', '2016-04-02', '2016-04-05', 'Cirurgia de emergência', 1, 5, 9, 1),
('2020-11-18', '2020-11-24', '2020-11-28', 'Cirurgia eletiva', 2, 6, 10, 2);

-- Inserindo quartos
INSERT INTO quarto (quarto_tipo, quarto_numero, quarto_andar, quarto_preco) VALUES 
('apartamento', 101, 1, 500.00),
('apartamento', 102, 1, 500.00),
('quarto duplo', 201, 2, 300.00),
('quarto duplo', 202, 2, 300.00),
('enfermaria', 301, 3, 150.00),
('enfermaria', 302, 3, 150.00),
('enfermaria', 303, 3, 150.00);

-- Inserindo enfermeiros
INSERT INTO enfermeiro (`enfermeiro_nome`, `enfermeiro_cpf`, `enfermeiro_cre`) VALUES 
    ('Carla Souza', '111.111.111-11', 'CRE-SP-123456'),
    ('Lucas Oliveira', '222.222.222-22', 'CRE-SP-654321'),
    ('Bruna Santo', '333.333.333-33', 'CRE-SP-987654'),
    ('Rafaela Costa', '444.444.444-44', 'CRE-SP-456789'),
    ('Paulo Ferreira', '555.555.555-55', 'CRE-SP-987654'),
    ('Camila Silva', '666.666.666-66', 'CRE-SP-789456'),
    ('Vinicius Almeida', '777.777.777-77', 'CRE-SP-321654'),
    ('Júlia Pereira', '888.888.888-88', 'CRE-SP-654987'),
    ('Tiago Rodrigues', '999.999.999-99', 'CRE-SP-159753'),
    ('Ana Lúcia Martins', '000.000.000-00', 'CRE-SP-753159');

-- Relacionando os enfermeiros com as internações
INSERT INTO enfermeiro_internacao (`enfermeiro_id`, `internacao_id`) VALUES 
    (1, 1),
    (2, 1),
    (3, 2),
    (4, 3),
    (5, 3),
    (6, 4),
    (7, 5),
    (8, 6),
    (9, 7),
    (10, 7),
    (2, 8),
    (3, 8),
    (4, 9),
    (5, 9),
    (6, 10),
    (7, 10);

-- Inserção de tipos de quartos
INSERT INTO tipoQuarto (tipo_quarto_descricao, tipo_quarto_valor) VALUES
('Apartamento', 500),
('Quarto Duplo', 300),
('Enfermaria', 150);
