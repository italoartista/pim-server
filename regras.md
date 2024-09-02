
# Regras de Negócio Avançadas para o Sistema de Gerenciamento de Informações sobre Produtos (PIM)

## 1. **Validações e Restrições**

1. **Validação de Preço Mínimo e Máximo**
   - **Regra:** O preço de um produto não pode ser inferior ao custo de aquisição e não pode ultrapassar um limite máximo definido.
   - **SQL Exemplo:**
     ```sql
     CREATE OR REPLACE FUNCTION validate_preco()
     RETURNS TRIGGER AS $$
     BEGIN
       IF NEW.preco < 10 THEN
         RAISE EXCEPTION 'Preço não pode ser inferior a R$10';
       ELSIF NEW.preco > 10000 THEN
         RAISE EXCEPTION 'Preço não pode exceder R$10.000';
       END IF;
       RETURN NEW;
     END;
     $$ LANGUAGE plpgsql;

     CREATE TRIGGER trg_validate_preco
     BEFORE INSERT OR UPDATE ON produtos
     FOR EACH ROW
     EXECUTE FUNCTION validate_preco();
     ```

2. **Verificação de Quantidade Mínima em Estoque**
   - **Regra:** Produtos não podem ser atualizados para uma quantidade em estoque que esteja abaixo de um mínimo definido.
   - **SQL Exemplo:**
     ```sql
     CREATE OR REPLACE FUNCTION check_min_estoque()
     RETURNS TRIGGER AS $$
     BEGIN
       IF NEW.quantidade_em_estoque < 5 THEN
         RAISE EXCEPTION 'Quantidade em estoque não pode ser inferior a 5 unidades';
       END IF;
       RETURN NEW;
     END;
     $$ LANGUAGE plpgsql;

     CREATE TRIGGER trg_check_min_estoque
     BEFORE UPDATE ON produtos
     FOR EACH ROW
     EXECUTE FUNCTION check_min_estoque();
     ```

## 2. **Transações e Integridade de Dados**

3. **Transação para Atualização de Estoque**
   - **Regra:** Quando o estoque de um produto é atualizado, todas as transações relacionadas devem ser registradas para garantir integridade.
   - **SQL Exemplo:**
     ```sql
     BEGIN;

     UPDATE produtos
     SET quantidade_em_estoque = quantidade_em_estoque - 10
     WHERE id = 1;

     INSERT INTO transacoes (conta_id, tipo_transacao, valor, data_transacao, descricao)
     VALUES (1, 'ajuste de estoque', -10, CURRENT_TIMESTAMP, 'Ajuste de estoque para produto ID 1');

     COMMIT;
     ```

4. **Atualização de Preço com Histórico**
   - **Regra:** Quando o preço de um produto é alterado, o histórico de preços deve ser registrado.
   - **SQL Exemplo:**
     ```sql
     CREATE TABLE historico_precos (
       id SERIAL PRIMARY KEY,
       produto_id INTEGER REFERENCES produtos(id),
       preco_anterior DECIMAL(15, 2),
       preco_novo DECIMAL(15, 2),
       data_alteracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
     );

     CREATE OR REPLACE FUNCTION log_preco_alterado()
     RETURNS TRIGGER AS $$
     BEGIN
       INSERT INTO historico_precos (produto_id, preco_anterior, preco_novo)
       VALUES (OLD.id, OLD.preco, NEW.preco);
       RETURN NEW;
     END;
     $$ LANGUAGE plpgsql;

     CREATE TRIGGER trg_log_preco
     BEFORE UPDATE OF preco ON produtos
     FOR EACH ROW
     EXECUTE FUNCTION log_preco_alterado();
     ```

## 3. **Consultas Avançadas**

5. **Relatório de Produtos com Baixo Estoque e Alto Preço**
   - **Regra:** Gerar um relatório dos produtos que estão com estoque abaixo de 10 unidades e cujo preço é superior a R$500.
   - **SQL Exemplo:**
     ```sql
     SELECT id, nome, preco, quantidade_em_estoque
     FROM produtos
     WHERE quantidade_em_estoque < 10 AND preco > 500;
     ```

6. **Produtos com Maior Variação de Preço**
   - **Regra:** Listar produtos com maior variação entre o preço mais baixo e o preço mais alto registrado no histórico.
   - **SQL Exemplo:**
     ```sql
     SELECT p.id, p.nome, MAX(h.preco_novo) - MIN(h.preco_novo) AS variacao
     FROM produtos p
     JOIN historico_precos h ON p.id = h.produto_id
     GROUP BY p.id, p.nome
     ORDER BY variacao DESC;
     ```

## 4. **Gerenciamento de Categorias e Fornecedores**

7. **Categoria com Mais Produtos**
   - **Regra:** Identificar a categoria que possui o maior número de produtos.
   - **SQL Exemplo:**
     ```sql
     SELECT categoria, COUNT(*) AS total_produtos
     FROM produtos
     GROUP BY categoria
     ORDER BY total_produtos DESC
     LIMIT 1;
     ```

8. **Fornecedores com Produtos Acima de Preço Médio**
   - **Regra:** Listar fornecedores que fornecem produtos cujo preço é superior ao preço médio dos produtos.
   - **SQL Exemplo:**
     ```sql
     WITH preco_medio AS (
       SELECT AVG(preco) AS media_preco
       FROM produtos
     )
     SELECT DISTINCT f.nome
     FROM fornecedores f
     JOIN produtos p ON f.id = p.fornecedor_id
     CROSS JOIN preco_medio pm
     WHERE p.preco > pm.media_preco;
     ```

## 5. **Segurança e Acesso**

9. **Permissões de Usuário para Alterações de Preço**
   - **Regra:** Apenas usuários com um papel específico podem alterar os preços dos produtos.
   - **SQL Exemplo:**
     ```sql
     CREATE OR REPLACE FUNCTION check_user_role()
     RETURNS TRIGGER AS $$
     BEGIN
       IF NOT EXISTS (SELECT 1 FROM usuarios WHERE id = CURRENT_USER_ID AND papel = 'gerente') THEN
         RAISE EXCEPTION 'Usuário não autorizado a alterar preços';
       END IF;
       RETURN NEW;
     END;
     $$ LANGUAGE plpgsql;

     CREATE TRIGGER trg_check_user_role
     BEFORE UPDATE OF preco ON produtos
     FOR EACH ROW
     EXECUTE FUNCTION check_user_role();
     ```

10. **Auditoria de Exclusões de Produtos**
    - **Regra:** Registar todas as exclusões de produtos em uma tabela de auditoria.
    - **SQL Exemplo:**
      ```sql
      CREATE TABLE auditoria_exclusoes (
        id SERIAL PRIMARY KEY,
        produto_id INTEGER,
        nome_produto VARCHAR(100),
        preco DECIMAL(15, 2),
        quantidade_em_estoque INTEGER,
        data_exclusao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      CREATE OR REPLACE FUNCTION log_exclusao()
      RETURNS TRIGGER AS $$
      BEGIN
        INSERT INTO auditoria_exclusoes (produto_id, nome_produto, preco, quantidade_em_estoque)
        VALUES (OLD.id, OLD.nome, OLD.preco, OLD.quantidade_em_estoque);
        RETURN OLD;
      END;
      $$ LANGUAGE plpgsql;

      CREATE TRIGGER trg_log_exclusao
      BEFORE DELETE ON produtos
      FOR EACH ROW
      EXECUTE FUNCTION log_exclusao();
      ```

---

Essas regras avançadas cobrem uma variedade de situações que você pode encontrar ao lidar com dados em um sistema de gerenciamento de produtos. Elas não só envolvem operações básicas de CRUD, mas também considerações complexas como integridade referencial, controle de acesso e manutenção de histórico. Praticar e implementar essas regras ajudará a solidificar suas habilidades com SQL e gerenciamento de banco de dados.