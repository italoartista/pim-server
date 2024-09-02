# Documento de Requisitos para o Sistema de Gerenciamento de Informações sobre Produtos (PIM)

## Visão Geral

O sistema de gerenciamento de informações sobre produtos (PIM) é projetado para gerenciar e manter informações detalhadas sobre produtos. Este sistema será desenvolvido utilizando a stack Node.js (Express) para o backend e PostgreSQL para o banco de dados.

## Requisitos Funcionais

### Operações Básicas de CRUD

1. **Criar um Produto**
   - **Endpoint:** `POST /produtos`
   - **Descrição:** Adiciona um novo produto ao sistema.
   - **Requisição:**
     ```json
     {
       "nome": "Nome do Produto",
       "descricao": "Descrição do Produto",
       "preco": 99.99,
       "quantidade_em_estoque": 100,
       "categoria": "Categoria do Produto"
     }
     ```
   - **Resposta:**
     ```json
     {
       "id": 1,
       "nome": "Nome do Produto",
       "descricao": "Descrição do Produto",
       "preco": 99.99,
       "quantidade_em_estoque": 100,
       "categoria": "Categoria do Produto"
     }
     ```

2. **Consultar um Produto**
   - **Endpoint:** `GET /produtos/:id`
   - **Descrição:** Recupera as informações de um produto específico.
   - **Resposta:**
     ```json
     {
       "id": 1,
       "nome": "Nome do Produto",
       "descricao": "Descrição do Produto",
       "preco": 99.99,
       "quantidade_em_estoque": 100,
       "categoria": "Categoria do Produto"
     }
     ```

3. **Atualizar um Produto**
   - **Endpoint:** `PUT /produtos/:id`
   - **Descrição:** Atualiza as informações de um produto existente.
   - **Requisição:**
     ```json
     {
       "nome": "Novo Nome do Produto",
       "descricao": "Nova Descrição do Produto",
       "preco": 89.99,
       "quantidade_em_estoque": 150,
       "categoria": "Nova Categoria do Produto"
     }
     ```
   - **Resposta:**
     ```json
     {
       "id": 1,
       "nome": "Novo Nome do Produto",
       "descricao": "Nova Descrição do Produto",
       "preco": 89.99,
       "quantidade_em_estoque": 150,
       "categoria": "Nova Categoria do Produto"
     }
     ```

4. **Excluir um Produto**
   - **Endpoint:** `DELETE /produtos/:id`
   - **Descrição:** Remove um produto do sistema.
   - **Resposta:**
     ```json
     {
       "message": "Produto excluído com sucesso."
     }
     ```

### Consultas Adicionais

5. **Listar Todos os Produtos**
   - **Endpoint:** `GET /produtos`
   - **Descrição:** Recupera uma lista de todos os produtos.
   - **Resposta:**
     ```json
     [
       {
         "id": 1,
         "nome": "Produto 1",
         "descricao": "Descrição do Produto 1",
         "preco": 99.99,
         "quantidade_em_estoque": 100,
         "categoria": "Categoria 1"
       },
       {
         "id": 2,
         "nome": "Produto 2",
         "descricao": "Descrição do Produto 2",
         "preco": 89.99,
         "quantidade_em_estoque": 150,
         "categoria": "Categoria 2"
       }
     ]
     ```

6. **Filtrar Produtos por Categoria**
   - **Endpoint:** `GET /produtos?categoria=Categoria`
   - **Descrição:** Recupera produtos que pertencem a uma categoria específica.
   - **Resposta:**
     ```json
     [
       {
         "id": 1,
         "nome": "Produto 1",
         "descricao": "Descrição do Produto 1",
         "preco": 99.99,
         "quantidade_em_estoque": 100,
         "categoria": "Categoria"
       }
     ]
     ```

## Regras de Negócio

1. **Nome do Produto**
   - O nome do produto deve ser único em todo o sistema.
   - O nome do produto deve ter entre 3 e 100 caracteres.

2. **Descrição do Produto**
   - A descrição pode ter até 500 caracteres.

3. **Preço**
   - O preço deve ser um valor positivo.
   - O preço não deve ser superior a R$ 10.000,00.

4. **Quantidade em Estoque**
   - A quantidade em estoque deve ser um valor não negativo.
   - A quantidade em estoque não deve exceder 1.000 unidades.

5. **Categoria**
   - A categoria deve ser uma string com até 50 caracteres.
   - O sistema deve permitir a criação de novas categorias se necessário.

6. **Produto Disponível**
   - Produtos com quantidade em estoque igual a 0 devem ser considerados como fora de estoque.

7. **Atualização de Preço**
   - O preço de um produto só pode ser atualizado se a quantidade em estoque for maior que 0.

8. **Data de Criação**
   - A data de criação do produto é registrada automaticamente e não pode ser alterada.

9. **Data de Atualização**
   - A data da última atualização é registrada automaticamente.

10. **Exclusão de Produto**
    - Produtos só podem ser excluídos se a quantidade em estoque for 0.

11. **Validação de CPF/CNPJ**
    - Se for necessário associar um fornecedor, o CPF/CNPJ deve ser validado.

12. **Categorias Predefinidas**
    - Algumas categorias podem ser predefinidas e não devem ser removidas.

13. **Histórico de Alterações**
    - Deve ser mantido um histórico das alterações de preço e quantidade.

14. **Limite de Produtos por Categoria**
    - Uma categoria pode conter no máximo 500 produtos.

15. **Restrições de Nome**
    - O nome do produto não deve conter caracteres especiais.

16. **Consistência de Dados**
    - Deve haver validação para garantir que não existam produtos duplicados.

17. **Relatórios de Estoque**
    - Deve ser possível gerar relatórios de produtos com baixo estoque (abaixo de 10 unidades).

18. **Armazenamento de Imagens**
    - Imagens dos produtos podem ser armazenadas e associadas a um produto.

19. **Registros de Erro**
    - Todos os erros de operações CRUD devem ser registrados em um log para análise.

20. **Permissões de Usuário**
    - Somente usuários com permissões apropriadas podem realizar operações de criação, atualização e exclusão de produtos.

