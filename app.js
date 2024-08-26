const express = require('express');
const db = require('./db');
const app = express();
const path = require('path');
const port = 3000;

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));
app.use(express.json());

// Consulta para obter todos os produtos
const consulta = `
 SELECT
    p.id AS product_id,
    p.name AS product_name,
    p.description AS product_description,
    pc.name AS category_name,
    ps.name AS supplier_name
FROM
    products p
INNER JOIN
    product_categories pc ON p.category_id = pc.id
INNER JOIN
    product_suppliers ps ON p.supplier_id = ps.id;
`;

// Rota para exibir produtos com JSON
app.get('/produtos', async (req, res) => {
  try {
    const result = await db.query(consulta);
    res.json(result.rows);
  } catch (err) {
    res.status(500).send('Erro ao conectar ao banco de dados');
  }
});

// Rota para exibir produtos com EJS
app.get('/', async (req, res) => {
  try {
    const result = await db.query(consulta);
    const products = result.rows; // Extraia o array de produtos
    res.render('products', { products });
  } catch (err) {
    res.status(500).send('Erro ao obter produtos');
  }
});

app.get('/cadastro', (req, res) => {
  res.render('cadastroProduto');
});

app.post('/cadastro', async (req, res) => {
  const { name, description, category_id, supplier_id } = req.body;
  const sql = `
    INSERT INTO products (name, description, category_id, supplier_id)
    VALUES ($1, $2, $3, $4)
  `;
  try {
    await db.query(sql, [name, description, category_id, supplier_id]);
    res.redirect('/');
  } catch (err) {
    res.status(500).send('Erro ao cadastrar produto');
  }
});

app.listen(port, () => {
  console.log(`Servidor Express ouvindo na porta ${port}`);
});
