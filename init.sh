#!/bin/bash

# Verificar se o diretório do projeto existe
if [ ! -d "pim-server" ]; then
  echo "Criando diretório do projeto..."
  mkdir pim-server
fi

cd pim-server

# Inicializar um novo projeto Node.js
echo "Inicializando o projeto Node.js..."
npm init -y

# Instalar dependências
echo "Instalando dependências do Express e PostgreSQL..."
npm install express pg dotenv

# Criar o arquivo .env para variáveis de ambiente
echo "Criando arquivo .env..."
cat > .env <<EOL
DB_USER=your_username
DB_HOST=localhost
DB_DATABASE=your_database
DB_PASSWORD=your_password
DB_PORT=5432
EOL

# Criar o arquivo db.js para configuração de conexão com PostgreSQL
echo "Criando arquivo de configuração db.js..."
cat > db.js <<EOL
const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_DATABASE,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,
});

module.exports = {
  query: (text, params) => pool.query(text, params),
  pool,
};
EOL

# Criar o arquivo app.js para configurar o Express.js
echo "Criando arquivo app.js..."
cat > app.js <<EOL
const express = require('express');
const db = require('./db');
const app = express();
const port = 3000;

app.use(express.json());

// Rota simples para testar a conexão
app.get('/', async (req, res) => {
  try {
    const result = await db.query('SELECT NOW()');
    res.send(`Servidor está funcionando. Hora atual no banco de dados: ${result.rows[0].now}`);
  } catch (err) {
    res.status(500).send('Erro ao conectar ao banco de dados');
  }
});

app.listen(port, () => {
  console.log(\`Servidor Express ouvindo na porta ${port}\`);
});
EOL

echo "Estrutura básica criada com sucesso. Para iniciar o servidor, execute 'node app.js'."
