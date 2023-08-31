-- Deleta todas as tabelas do Banco (usar apenas em ambiente de testes)

DO $$ 
DECLARE 
    tabela_atual text;
BEGIN 
    FOR tabela_atual IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') 
    LOOP 
        EXECUTE 'DROP TABLE IF EXISTS ' || tabela_atual || ' CASCADE'; 
    END LOOP; 
END $$;


-- Criar Banco de Dados

CREATE DATABASE EcommerceSerratec
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

-- opcional 

COMMENT ON DATABASE EcommerceSerratec
    IS 'E-commerce tradicional'

--


--Criação das Tabelas

-- Incio

CREATE TABLE Cliente (
    codigo SERIAL PRIMARY KEY,
    nome_completo VARCHAR(200) NOT NULL,
    email VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) NOT NULL,
    data_nascimento DATE
);

CREATE TABLE Usuario (
    
	Cliente_codigo INT PRIMARY KEY,
    nome_usuario VARCHAR(50) NOT NULL,
    senha CHAR(8) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE,
	FOREIGN KEY (Cliente_codigo) REFERENCES Cliente(codigo)

	
);
	
   
CREATE TABLE Funcionario (
    codigo SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) NOT NULL	
	
);

CREATE TABLE Endereco (
    Cliente_codigo INT PRIMARY KEY,
    rua VARCHAR(100) NOT NULL,
	numero VARCHAR(10) NOT NULL,
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    estado VARCHAR(5) NOT NULL,
    cep VARCHAR(12) NOT NULL,
	FOREIGN KEY (Cliente_codigo) REFERENCES Cliente(codigo)
);
     

CREATE TABLE Pedido (
    codigo SERIAL PRIMARY KEY,
    data_realizacao DATE NOT NULL,
    cliente_codigo INT REFERENCES Cliente(codigo),
    funcionario_codigo INT,
    FOREIGN KEY (funcionario_codigo) REFERENCES Funcionario(codigo)
);
   
   
CREATE TABLE Categoria (    
	codigo SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
	descricao TEXT
);

CREATE TABLE Produto (
    codigo SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    quantidade_estoque INT NOT NULL,
    valor_unitario DECIMAL(10, 2) NOT NULL,
	descricao_produto TEXT,
    data_fabricacao DATE,
    funcionario_id INT REFERENCES Funcionario(codigo),
	categoria_id INT REFERENCES Categoria(codigo)
	);	
	
CREATE TABLE PedidoItem (
    PRIMARY KEY (pedido_codigo, produto_codigo),
    pedido_codigo INT REFERENCES Pedido(codigo),
    produto_codigo INT REFERENCES Produto(codigo),
    quantidade INT NOT NULL
);

-- Tabela NotaFiscal (opcional)

CREATE TABLE NotaFiscal (
    numero_nota serial PRIMARY KEY,
    data_emissao date NOT NULL,
    pedido_id integer UNIQUE REFERENCES Pedido(codigo),
    valor_total numeric(10, 2) NOT NULL
);

-- Populações das tabelas

	
INSERT INTO Cliente (nome_completo,email,cpf,data_nascimento)
VALUES
	('Janaelson soares','janaelson@email.com',14254664500,'12/10/1987'),	
    ('Rodrigo Rocha','rodrigo@email.com' ,46535663511, '12/10/1986'),
    ('Ana Menezes','ana@email.com', 95662445541,'02/10/1990'),
    ('Steffany Ouverney','steffany@email.com', 99465656600,'15/08/1998'),
    ('Ramon Matos','ramon@email.com', 11553113522, '10/06/1980'),
    ('Adriane','adriane@email.com' ,11245523567, '12/10/1986');


INSERT INTO Usuario(nome_usuario,senha,Cliente_codigo)
VALUES
	('janaelson','123456',1),
	('Rodrigo','321321',2),
	('Ana','213456',3),
	('Steffany','654654',4),
	('Ramon','456456',5),
	('Adriane','312546',6);


INSERT INTO Endereco (rua,numero,bairro,cidade,estado,cep,Cliente_codigo)
VALUES
	('Mato Grosso','180','Santa Cecilia','Teresopolis','RJ','26958250', 1),
	('Francisco Sá','40','Várzea','Teresopolis','RJ','25989250', 2),
	('Sebastião Lacerda','30','Alto','Teresopolis','RJ','25146250', 3),
	('Machado de Assis','100','Centro','Friburgo','RJ','28605000', 4),
	('Santa Catarina','200','Centro','Friburgo','RJ','28605090', 5),
	('Francisco Sá','77','Várzea','Teresopolis','RJ','25989250', 6);
	
	
INSERT INTO Funcionario (nome, cpf)
VALUES
	('Carlos Alberto',01280777001), 
	('Eduardo Silva',44081835047),
	('Elaine Rocha',50017749000),
	('André Soares',43604957060),
	('Jorge Pereira',43604957060);


INSERT INTO Categoria (nome, descricao)
VALUES
	('Calcados', 'tenis, sapato, botas, salto alto'), 
	('Adulto','de 18 a 40 anos'),
	('Infantil','de 0 a 14 anos'),
	('Feminino','vestidos, saias, calças, moda intima'),
	('Masculino','Camisas, calças, bermudas, cuecas');


INSERT INTO Pedido (cliente_codigo, data_realizacao, Funcionario_codigo)
VALUES
	(1, '12/11/2005', 1),
	(2, '12/11/2010', 2), 
	(3, '01/12/2023', 3),
	(4, '05/06/2009', 4),
	(5, '10/11/2011', 5);


INSERT INTO Produto (nome,descricao_produto, quantidade_estoque, data_fabricacao, valor_unitario, 
					funcionario_id, categoria_id)
VALUES
	('Camisa Polo Nike', 'tamanho P', 14, '2023-10-12', 350.00, 2, 5), 
	('Tênis Adidas', 'tamanho 31 a 43', 10, '2023-05-01', 450.00, 5, 1), 
	('Vestido Longo', 'tamanho M ou G', 5, '2023-09-01', 200.00, 4, 4), 
	('Camisa Mickey Infantil', 'tamanho PP ou P', 10, '2023-02-05', 120.00, 3, 3), 
	('Calça Social', 'tamanho 41 ao 46', 20, '2023-03-03', 200.00, 2, 2);


INSERT INTO Pedidoitem (pedido_codigo,produto_codigo,quantidade)
    VALUES
    (1,2,5),
    (1,1,10),
    (2,3,3),
    (3,4,2),
    (4,1,1),
    (5,1,6),
    (5,5,12),
    (5,2,7);
		
		
INSERT INTO Notafiscal (numero_nota, data_emissao, pedido_id, valor_total)
VALUES
	(1, '22/08/2023', 2, '2.200'),
	(2, '22/08/2023', 3, '500.00'),
	(3, '22/08/2023', 5, '1.200'),
	(4, '22/08/2023', 1, '900.00'),
	(5, '22/08/2023', 4, '200.00');




-- utilitarios


-- atualização coluna cliente_codigo na tabela Pedido

UPDATE Pedido SET  cliente_codigo ='1' WHERE data_realizacao='2005-11-12';
UPDATE Pedido SET  cliente_codigo ='3' WHERE data_realizacao='2010-11-12';
UPDATE Pedido SET  cliente_codigo ='5' WHERE data_realizacao='2023-12-01';
UPDATE Pedido SET  cliente_codigo ='2' WHERE data_realizacao='2009-06-05';
UPDATE Pedido SET  cliente_codigo ='4' WHERE data_realizacao='2011-11-10';


-- Fim  (Após essa execução, foram criadas as tabelas e inseridas as informações pertinentes)


-- DELETE tabela pedido


DELETE FROM Categoria WHERE nome = 'adulto'


-- SELECT em todas as tabelas do banco


SELECT * FROM Cliente order by codigo
SELECT * FROM Pedido
SELECT * FROM Funcionario
SELECT * FROM Categoria
SELECT * FROM Produto order by codigo
SELECT * FROM Pedidoitem
SELECT * FROM NotaFiscal
SELECT * FROM Endereco
SELECT * FROM Usuario_Cliente 
SELECT * FROM Usuario


-- agrupamento com soma


SELECT pedido_codigo,
SUM(quantidade) AS Qt_produto
FROM Pedidoitem
GROUP BY pedido_codigo
ORDER BY pedido_codigo;

-- Join

SELECT
	u.nome_usuario,senha,ativo,
	c.nome_completo,email,cpf,data_nascimento
FROM
	usuario u 
	inner JOIN Cliente c ON u.Cliente_codigo = c.codigo
	

-- Count e Order

SELECT 

    p.cliente_codigo, c.nome_completo, COUNT(p.cliente_codigo) pedidos_por_cliente
FROM 
    cliente c
    INNER JOIN pedido p ON p.cliente_codigo = c.codigo
GROUP BY 
    c.nome_completo, p.cliente_codigo
ORDER BY 
     COUNT(p.cliente_codigo) DESC, p.cliente_codigo;
	 
	

-- Exibir Nota Fiscal

-- Opção 1
	 
SELECT 
    p.nome AS nome_produto,
    p.descricao_produto,
    p.quantidade_estoque,
    p.data_fabricacao,
    p.valor_unitario,
    c.nome AS nome_categoria,
    c.descricao AS descricao_categoria
FROM
    produto AS p
    INNER JOIN categoria AS c ON p.categoria_id = c.codigo;
SELECT  
    c.nome_completo AS nome_cliente,
    pe.codigo AS codigo_pedido,
    STRING_AGG(pr.nome, ', ') AS nome_produtos,
    STRING_AGG(pr.descricao_produto, ', ') AS descricao_produtos,
    pe.data_realizacao AS data_realizacao_pedido,
    SUM(pr.valor_unitario * pi.quantidade) AS valor_total_pedido,
    c.cpf,
    e.cep,
    e.estado,
    e.cidade,
    e.bairro,
    e.rua,
    e.numero
FROM
    pedidoitem pi
	INNER JOIN produto pr ON pi.produto_codigo = pr.codigo
    INNER JOIN pedido pe ON pi.pedido_codigo = pe.codigo
	INNER JOIN cliente c ON pe.cliente_codigo = c.codigo
	LEFT JOIN endereco e ON c.codigo = e.Cliente_codigo
WHERE 
    pi.pedido_codigo = 3  -- aqui onde seleciona qual pedido deseja visualizar
GROUP BY 
    c.nome_completo,
    pe.codigo,
    pe.data_realizacao,
    c.cpf,
    e.cep,
    e.estado,
    e.cidade,
    e.bairro,
    e.rua,
    e.numero;
	
	
-- Opção 2

SELECT
    nf.numero_nota AS numero_Nfe,
    nf.data_emissao AS emissao_Nfe,
    c.nome_completo AS cliente,
    c.cpf AS cpf_cliente,
    p.codigo AS codigo_pedido,
    p.data_realizacao AS data_pedido,
    pr.nome AS produto,
    pr.descricao_produto AS detalhe_item,
    pi.quantidade AS quantidade_item,
    pr.valor_unitario AS vl_produto,
    ca.nome AS categoria

FROM
    NotaFiscal nf
INNER JOIN Pedido p ON nf.pedido_id = p.codigo
INNER JOIN Cliente c ON p.cliente_codigo = c.codigo
INNER JOIN PedidoItem pi ON p.codigo = pi.pedido_codigo
INNER JOIN Produto pr ON pi.produto_codigo = pr.codigo
INNER JOIN Categoria ca ON pr.categoria_id = ca.codigo

WHERE nf.numero_nota = 2; -- Aqui você coloca qual nota vai consultar 


--opção 3

SELECT  
    c.nome_completo AS nome_cliente,
    pe.codigo AS codigo_pedido,
    STRING_AGG(pr.nome, '/ ') AS nome_produtos,
    STRING_AGG(pr.descricao_produto, '/ ') AS descricao_produtos,
    STRING_AGG(CAST(pr.valor_unitario AS TEXT), '/ ') AS valores_unitarios,
    STRING_AGG(CAST(pi.quantidade AS TEXT), '/ ') AS quantidade_por_produto,
    STRING_AGG(CAST(pr.valor_unitario * pi.quantidade AS TEXT), '/ ') AS valor_a_pagar_por_produto,
    pe.data_realizacao AS data_realizacao_pedido,
    SUM(pr.valor_unitario * pi.quantidade) AS valor_total_pedido,
    c.cpf,
    e.cep,
    e.estado,
    e.cidade,
    e.bairro,
    e.rua,
    e.numero
FROM
    pedidoitem pi
    INNER JOIN produto pr ON pi.produto_codigo = pr.codigo
    INNER JOIN pedido pe ON pi.pedido_codigo = pe.codigo
    INNER JOIN cliente c ON pe.cliente_codigo = c.codigo
    LEFT JOIN endereco e ON c.codigo = e.Cliente_codigo
WHERE 
    pi.pedido_codigo = 5
GROUP BY 
    c.nome_completo,
    pe.codigo,
    pe.data_realizacao,
    c.cpf,
    e.cep,
    e.estado,
    e.cidade,
    e.bairro,
    e.rua,
    e.numero;  

-- Bonus

-- Relatorio de Cliente :

SELECT 
    c.nome_completo as Nome, 
    sum(pi.quantidade) as "Total de itens comprados", 
    sum(nf.valor_total) as "Valor total comprado"    
FROM Cliente as c
    INNER JOIN Pedido as p ON p.cliente_codigo = c.codigo
    INNER JOIN PedidoItem as pi ON pi.pedido_codigo = p.codigo
    INNER JOIN NotaFiscal as nf ON nf.pedido_id = p.codigo
GROUP BY 
    c.nome_completo
ORDER BY
    sum(nf.valor_total) DESC	