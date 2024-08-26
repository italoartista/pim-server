Table product_categories {
  id integer [primary key]
  name varchar
  description text
}

Table products {
  id integer [primary key]
  name varchar
  description text
  category_id integer
  supplier_id integer
  created_at timestamp
  updated_at timestamp
}

Table product_attributes {
  id integer [primary key]
  name varchar
  type varchar // tipo do atributo (por exemplo, 'texto', 'número', 'opções')
}

Table product_attribute_values {
  id integer [primary key]
  product_id integer
  attribute_id integer
  value varchar
}

Table product_variants {
  id integer [primary key]
  product_id integer
  sku varchar // Stock Keeping Unit
  price decimal(10, 2)
  stock integer
}

Table product_prices {
  id integer [primary key]
  product_id integer
  variant_id integer
  price decimal(10, 2)
  currency varchar // moeda do preço
  price_type varchar // tipo de preço (por exemplo, 'regular', 'promocional')
}

Table product_stock {
  id integer [primary key]
  product_id integer
  variant_id integer
  quantity integer
  location varchar // localização do estoque (se aplicável)
}

Table product_suppliers {
  id integer [primary key]
  name varchar
  contact_info text
}

Table product_reviews {
  id integer [primary key]
  product_id integer
  user_id integer
  rating integer // de 1 a 5
  review_text text
  created_at timestamp
}

Table product_images {
  id integer [primary key]
  product_id integer
  image_url varchar
  alt_text varchar
}

Table product_promotions {
  id integer [primary key]
  product_id integer
  promotion_type varchar // tipo de promoção (por exemplo, 'desconto', 'compre um leve dois')
  value decimal(10, 2) // valor do desconto ou promoção
  start_date timestamp
  end_date timestamp
}

Ref: products.category_id > product_categories.id // Muitos para um: cada produto pertence a uma categoria

Ref: products.supplier_id > product_suppliers.id // Muitos para um: cada produto é fornecido por um fornecedor

Ref: product_attribute_values.product_id > products.id // Muitos para um: cada valor de atributo pertence a um produto

Ref: product_attribute_values.attribute_id > product_attributes.id // Muitos para um: cada valor de atributo refere-se a um atributo específico

Ref: product_variants.product_id > products.id // Muitos para um: cada variante pertence a um produto

Ref: product_prices.product_id > products.id // Muitos para um: cada preço refere-se a um produto

Ref: product_prices.variant_id > product_variants.id // Muitos para um: cada preço pode estar associado a uma variante específica

Ref: product_stock.product_id > products.id // Muitos para um: o estoque refere-se a um produto

Ref: product_stock.variant_id > product_variants.id // Muitos para um: o estoque pode ser para uma variante específica

Ref: product_reviews.product_id > products.id // Muitos para um: cada revisão refere-se a um produto

Ref: product_images.product_id > products.id // Muitos para um: cada imagem refere-se a um produto

Ref: product_promotions.product_id > products.id // Muitos para um: cada promoção refere-se a um produto
