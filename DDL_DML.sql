-- 1. LEITOR
CREATE TABLE leitor (
    id_leitor INT PRIMARY KEY IDENTITY(1,1),
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL,
    numero VARCHAR(20),
    cep VARCHAR(10)
)

CREATE TABLE aluno (
    id_leitor INT PRIMARY KEY,
    CONSTRAINT FK_aluno_leitor FOREIGN KEY (id_leitor) REFERENCES leitor(id_leitor) 
)

CREATE TABLE professor (
    id_leitor INT PRIMARY KEY,
    CONSTRAINT FK_professor_leitor FOREIGN KEY (id_leitor) REFERENCES leitor(id_leitor)
)

-- 2. BIBLIOTECÁRIO
CREATE TABLE bibliotecario (
    id_bibliotecario INT PRIMARY KEY IDENTITY(1,1),
    nome VARCHAR(150) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE
)

-- 3. TABELAS DE APOIO / DOMÍNIOS
CREATE TABLE autor (
    id_autor INT PRIMARY KEY IDENTITY(1,1),
    nome VARCHAR(150) NOT NULL,
    nacionalidade VARCHAR(100)
)

CREATE TABLE categoria (
    id_categoria INT PRIMARY KEY IDENTITY(1,1),
    nome_categ VARCHAR(100) NOT NULL
)

CREATE TABLE editora (
    id_editora INT PRIMARY KEY IDENTITY(1,1),
    nome_editora VARCHAR(150) NOT NULL
)

CREATE TABLE idioma (
    id_linguagem INT PRIMARY KEY IDENTITY(1,1),
    idioma VARCHAR(50) NOT NULL
)

CREATE TABLE local (
    id_local INT PRIMARY KEY IDENTITY(1,1),
    corredor VARCHAR(50),
    estante VARCHAR(50),
    prateleira VARCHAR(50)
)

-- 4. LIVRO E SEUS RELACIONAMENTOS N:N
CREATE TABLE livro (
    isbn VARCHAR(20) PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    ano_publicacao INT,
    edicao VARCHAR(20),
    id_editora INT NOT NULL,
    id_linguagem INT NOT NULL,
    CONSTRAINT FK_livro_editora FOREIGN KEY (id_editora) REFERENCES editora(id_editora),
    CONSTRAINT FK_livro_idioma FOREIGN KEY (id_linguagem) REFERENCES idioma(id_linguagem)
)

CREATE TABLE livro_autores (
    isbn VARCHAR(20) NOT NULL,
    id_autor INT NOT NULL,
    CONSTRAINT PK_livro_autores PRIMARY KEY (isbn, id_autor),
    CONSTRAINT FK_la_livro FOREIGN KEY (isbn) REFERENCES livro(isbn) ON DELETE CASCADE,
    CONSTRAINT FK_la_autor FOREIGN KEY (id_autor) REFERENCES autor(id_autor)
)

CREATE TABLE livro_categoria (
    isbn VARCHAR(20) NOT NULL,
    id_categoria INT NOT NULL,
    CONSTRAINT PK_livro_categoria PRIMARY KEY (isbn, id_categoria),
    CONSTRAINT FK_lc_livro FOREIGN KEY (isbn) REFERENCES livro(isbn) ON DELETE CASCADE,
    CONSTRAINT FK_lc_categoria FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
)

-- 5. EXEMPLAR
CREATE TABLE exemplar (
    num_tombo INT PRIMARY KEY IDENTITY(1,1),
    status VARCHAR(30) NOT NULL,
    isbn VARCHAR(20) NOT NULL,
    id_local INT NOT NULL,
    CONSTRAINT FK_exemplar_livro FOREIGN KEY (isbn) REFERENCES livro(isbn),
    CONSTRAINT FK_exemplar_local FOREIGN KEY (id_local) REFERENCES local(id_local)
)

-- 6. RESERVA
CREATE TABLE reserva (
    id_reserva INT PRIMARY KEY IDENTITY(1,1),
    dt_reserva DATE NOT NULL,
    status_reserva VARCHAR(30) NOT NULL,
    id_leitor INT NOT NULL,
    CONSTRAINT FK_reserva_leitor FOREIGN KEY (id_leitor) REFERENCES leitor(id_leitor)
)

-- 6.1 ITENS_RESERVADOS
CREATE TABLE itens_reservados (
    id_reserva INT NOT NULL,
    num_tombo INT NOT NULL,
    CONSTRAINT PK_itens_reservados PRIMARY KEY (id_reserva, num_tombo),
    CONSTRAINT FK_ir_reserva FOREIGN KEY (id_reserva) REFERENCES reserva(id_reserva),
    CONSTRAINT FK_ir_exemplar FOREIGN KEY (num_tombo) REFERENCES exemplar(num_tombo)
)

-- 7. EMPRÉSTIMO
CREATE TABLE emprestimo (
    id_emprestimo INT PRIMARY KEY IDENTITY(1,1),
    dt_emprestimo DATE NOT NULL,
    dt_devolucao DATE NOT NULL,
    id_leitor INT NOT NULL,
    id_bibliotecario INT NOT NULL,
    CONSTRAINT FK_emp_leitor FOREIGN KEY (id_leitor) REFERENCES leitor(id_leitor),
    CONSTRAINT FK_emp_biblio FOREIGN KEY (id_bibliotecario) REFERENCES bibliotecario(id_bibliotecario)
)
-- 8 ITENS EMPRÉSTIMOS
CREATE TABLE itens_emprestimo (
    id_emprestimo INT NOT NULL,
    num_tombo INT NOT NULL,
    id_devolucao INT NULL,
    CONSTRAINT PK_itens_emprestimo PRIMARY KEY (id_emprestimo, num_tombo),
    CONSTRAINT FK_ie_emprestimo FOREIGN KEY (id_emprestimo) REFERENCES emprestimo(id_emprestimo),
    CONSTRAINT FK_ie_exemplar FOREIGN KEY (num_tombo) REFERENCES exemplar(num_tombo),
    CONSTRAINT FK_ie_devolucao FOREIGN KEY (id_devolucao) REFERENCES devolucao(id_devolucao)
)

-- 9. DEVOLUÇÃO 
CREATE TABLE devolucao (
    id_devolucao INT PRIMARY KEY IDENTITY(1,1),
    dt_devolucao_real DATE NOT NULL
)
	
-- 10. MULTA
CREATE TABLE multa (
    id_multa INT PRIMARY KEY IDENTITY(1,1),
    valor_multa DECIMAL(10,2) NOT NULL,
    id_devolucao INT NOT NULL UNIQUE,
    CONSTRAINT FK_multa_devolucao FOREIGN KEY (id_devolucao) REFERENCES devolucao(id_devolucao)
)

INSERT INTO leitor (nome, email, cep, numero)
VALUES
('Alexandre' , 'alexandre@aluno.com', '12711450' , '12997093080'),
('Hubert' , 'Hubert@aluno.com', '12711000' , '12997093010'),
('Gabriel' , 'Gabriel@aluno.com', '12711111' , '12997223080'),
('Luis' , 'Luis@aluno.com', '12711222' , '11997088080'),
('João' , 'Joao@aluno.com', '12711333' , '35997096680');

select * from leitor;

DELETE FROM leitor 
WHERE id_leitor = 2;

-- comanndos de update. 'coloquei 4 por achar 2 pouco.'
-- 1. dados de contato de um leitor
UPDATE leitor 
SET email = 'luis.novoemail@aluno.com', numero = '11988887777'
WHERE id_leitor = 4;

-- 2. status de um exemplar
UPDATE exemplar 
SET status = 'Emprestado'
WHERE num_tombo = 1;

-- 3. cancelando uma reserva
UPDATE reserva 
SET status_reserva = 'Cancelada'
WHERE id_reserva = 12;

-- 4. corrigindo o ano e a edição de um livro
UPDATE livro 
SET ano_publicacao = 2024, edicao = '2ª Edição'
WHERE isbn = '978-85-1234-567';
