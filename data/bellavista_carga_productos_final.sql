-- =========================================================================
-- BELLAVISTA MINIMARKET — CARGA FINAL DE PRODUCTOS
-- Preparado desde: productos_unicos_precios_venta_40 (1).xlsx
-- Fecha: 10/06/2026
--
-- Qué hace:
-- 1) Asegura categorías.
-- 2) Limpia destacados anteriores.
-- 3) Deja inactivos productos antiguos que NO estén en esta carga.
-- 4) Inserta/actualiza 146 productos.
-- 5) Deja destacados de portada y marca revisión interna cuando falta precio.
--
-- Ejecutar en Supabase Dashboard → SQL Editor → New query → Run.
-- =========================================================================

begin;

-- Categorías base
insert into public.categories (name, slug, icon, position, active) values
  ('Panadería y Pastelería',  'panaderia',         'Croissant',      1, true),
  ('Bebidas y Licores',       'bebidas',           'Wine',           2, true),
  ('Lácteos y Embutidos',     'lacteos-embutidos', 'Milk',           3, true),
  ('Abarrotes',               'abarrotes',         'ShoppingBasket', 4, true),
  ('Snacks y Golosinas',      'snacks',            'Cookie',         5, true),
  ('Frutas y Verduras',       'frutas-verduras',   'Apple',          6, true),
  ('Carnes y Congelados',     'carnes-congelados', 'Beef',           7, true),
  ('Aseo y Hogar',            'aseo-hogar',        'Sparkles',       8, true),
  ('Higiene Personal',        'higiene-personal',  'Bath',           9, true),
  ('Cigarros',                'cigarros',          'Cigarette',     10, true),
  ('Farmacia',                'farmacia',          'Pill',          11, true),
  ('Otros',                   'otros',             'Package',       12, true)
on conflict (slug) do update
set name = excluded.name,
    icon = excluded.icon,
    position = excluded.position,
    active = true,
    updated_at = now();

-- Dejar limpia la portada antes de cargar destacados nuevos
update public.products
set featured = false,
    position = 1000,
    updated_at = now();

-- Si había catálogo anterior, esta carga pasa a ser la lista definitiva visible.
-- Los productos no incluidos quedan ocultos, no borrados.
update public.products
set active = false,
    featured = false,
    updated_at = now()
where sku not in ('BV-MAIN-PAN-FRESCO', '7802900120016', '7802900121013', 'BV-MAIN-QUESO-NEGRETE', 'BV-MAIN-QUESO-QUILLAYES-LAMINADO', '780197008402', '780196500974', 'BV-MAIN-PALTA', 'BV-HUEVO-UNIDAD', 'BV-HUEVO-MAPLE', 'BV-MAIN-HARINA', 'BV-MAIN-HARINA-TOSTADA', 'BV-MAIN-CONFORT', 'BV-MAIN-CERVEZA-LATA-BOTELLA', '7807975003967', '7802615006551', '7804695410016', 'BV-MAIN-SALSA-DE-TOMATE-POMAROLA-SAN-REMO', 'BV-MAIN-COCA-COLA-LATA-350-ML', 'BV-MAIN-COCA-COLA-500-ML', 'BV-MAIN-COCA-COLA-1-5-L', 'BV-MAIN-COCA-COLA-2-L', 'BV-MAIN-COCA-COLA-3-L', 'BV-MAIN-MONSTER-ENERGY', 'BV-MAIN-SCORE-ENERGY-DRINK', '780292077542', 'BV-MAIN-CABALLA-EN-CONSERVA', 'BV-KENT-IKON-MIX-20', 'BV-KENT-ROSE', 'BV-KENT-TRUE', 'BV-LUCKY-STR-BLUE-BOX-20', 'BV-PALL-MALL-CLICK-XL', 'BV-MAIN-JUGO-WATTS', 'BV-MAIN-PRESTOBARBA', 'BV-MAIN-SAL', '7801505231912', 'BV-MAIN-ENDULZANTE', '7801875069360', '7801875069153', 'BV-MAIN-CLORO', 'BV-MAIN-CLORO-GEL', 'BV-MAIN-DETERGENTE-OMO', 'BV-MAIN-QUIX-LAVALOZAS', 'BV-MAIN-CIF-LIMPIADOR', 'BV-MAIN-MATAMOSCAS', '7802950002119', 'BV-MAIN-TE', 'BV-MAIN-CAFE-EN-SOBRE', '780292000782', '7801320000007', '779027200058', '7802420011528', '780242006195', '780264000142', '7802950005943', '7802950005974', '7790580243678', '780540005746', '7613034279316', '7613034279750', '7802215121258', '7802225428206', '7802225428361', '7802225538121', '7802225426718', '780296017255', '7802575002235', '7802500001029', '7613030121046', '7613287755841', '7805000322502', '7803000000659', '7802200132696', '7801916029726', '41789001925', '780196000718', '780197004305', '41789002915', '7801620005160', '7802575220158', '7802575220783', '7809511721655', '780797500661', '780797500647', '7801300001024', '7591066711014', '7622201715236', '7613034276490', '7613032415679', '761303241580', '7613030120582', '91678', '8445290118288', '780290006025', '7613030049803', '761328704460', '780295000492', '780295000915', '844529179238', '789300065253', '780295001047', '762220197560', '780290005896', '7802920005836', '7801907008402', '780290000220', '780290230227', '780290230241', '780290230258', '780242001511', '7802900105013', '7802575012210', '2050003512367', '7802900600006', '7802200230293', '7802225310185', '7802225310192', '780220013476', '780220002015', '7802225130882', '780215303401', '7802230082503', '7802230082527', '7802230082534', '7802215512421', '7802215514326', '7802225689014', '7802225614498', '780221550466', '7622201717629', '7802225412131', '7906220802761', '7896591453274', '8410525127465', '841052519039', '7896451921345', '7896591453106', '7896451921321', '7802420170522', '7807975009754', '54300090018', '7702011305510', '7790580178208', '7801930025674', '7801930025711', '7613030612346');

with incoming (sku, ean, name, name_normalized, slug, category_slug, price, cost, stock, unit, active, featured, needs_review, image_url, image_source, position) as (
  values
  ('BV-MAIN-PAN-FRESCO', NULL, 'Pan fresco', 'pan fresco', 'pan-fresco-fresco', 'panaderia', 0, 0, 0, 'unidad', true, true, 'Falta precio/formato: definir si es unidad, bolsa, kilo o marraqueta. | FALTA PRECIO: editar desde backend antes de vender.', NULL, 'manual', 10),
  ('7802900120016', '7802900120016', 'Mantequilla Soprole Pan 125 g', 'mantequilla soprole pan 125 g', 'mantequilla-soprole-pan-125-g-120016', 'lacteos-embutidos', 1750, 1250, 0, 'unidad', true, true, 'Confirmar tamaño/formato antes de publicar definitivo.', NULL, 'excel', 20),
  ('7802900121013', '7802900121013', 'Mantequilla Soprole Pan 250 g', 'mantequilla soprole pan 250 g', 'mantequilla-soprole-pan-250-g-121013', 'lacteos-embutidos', 3486, 2490, 0, 'unidad', true, true, 'Confirmar tamaño/formato antes de publicar definitivo.', NULL, 'excel', 21),
  ('BV-MAIN-QUESO-NEGRETE', NULL, 'Queso Negrete', 'queso negrete', 'queso-negrete-egrete', 'lacteos-embutidos', 0, 0, 0, 'unidad', true, true, 'Falta precio y formato. | FALTA PRECIO: editar desde backend antes de vender.', NULL, 'manual', 30),
  ('BV-MAIN-QUESO-QUILLAYES-LAMINADO', NULL, 'Queso Quillayes laminado', 'queso quillayes laminado', 'queso-quillayes-laminado-minado', 'lacteos-embutidos', 0, 0, 0, 'unidad', true, true, 'Falta precio y formato. | FALTA PRECIO: editar desde backend antes de vender.', NULL, 'manual', 31),
  ('780197008402', '780197008402', 'Vienesas tradicionales pack chico', 'vienesas tradicionales pack chico', 'vienesas-tradicionales-pack-chico-008402', 'lacteos-embutidos', 1288, 920, 0, 'unidad', true, true, 'Nombre repetido o formato abreviado: revisar tamaño/sabor/marca. | Confirmar marca y cantidad del pack.', NULL, 'excel', 50),
  ('780196500974', '780196500974', 'Vienesas tradicionales pack familiar', 'vienesas tradicionales pack familiar', 'vienesas-tradicionales-pack-familiar-500974', 'lacteos-embutidos', 4886, 3490, 0, 'unidad', true, true, 'Nombre repetido o formato abreviado: revisar tamaño/sabor/marca. | Confirmar marca y cantidad del pack.', NULL, 'excel', 51),
  ('BV-MAIN-PALTA', NULL, 'Palta', 'palta', 'palta-npalta', 'frutas-verduras', 0, 0, 0, 'unidad', true, true, 'Falta precio y unidad de venta: unidad/kilo. | FALTA PRECIO: editar desde backend antes de vender.', NULL, 'manual', 60),
  ('BV-HUEVO-UNIDAD', NULL, 'Huevo unidad', 'huevo unidad', 'huevo-unidad-unidad', 'lacteos-embutidos', 300, 0, 0, 'unidad', true, true, NULL, NULL, 'manual', 70),
  ('BV-HUEVO-MAPLE', NULL, 'Maple de huevos', 'maple de huevos', 'maple-de-huevos-omaple', 'lacteos-embutidos', 8500, 0, 0, 'maple', true, true, NULL, NULL, 'manual', 71),
  ('BV-MAIN-HARINA', NULL, 'Harina', 'harina', 'harina-harina', 'abarrotes', 0, 0, 0, 'unidad', true, true, 'Falta precio y formato/peso. | FALTA PRECIO: editar desde backend antes de vender.', NULL, 'manual', 80),
  ('BV-MAIN-HARINA-TOSTADA', NULL, 'Harina tostada', 'harina tostada', 'harina-tostada-ostada', 'abarrotes', 0, 0, 0, 'unidad', true, true, 'Falta precio y formato/peso. | FALTA PRECIO: editar desde backend antes de vender.', NULL, 'manual', 81),
  ('BV-MAIN-CONFORT', NULL, 'Confort', 'confort', 'confort-onfort', 'higiene-personal', 0, 0, 0, 'unidad', true, true, 'Falta precio y formato: rollos/pack. | FALTA PRECIO: editar desde backend antes de vender.', NULL, 'manual', 90),
  ('BV-MAIN-CERVEZA-LATA-BOTELLA', NULL, 'Cerveza lata/botella', 'cerveza lata/botella', 'cerveza-lata-botella-otella', 'bebidas', 0, 0, 0, 'unidad', true, true, 'Falta precio, marca y formato. | FALTA PRECIO: editar desde backend antes de vender.', NULL, 'manual', 100),
  ('7807975003967', '7807975003967', 'Arroz grado 1 grano largo', 'arroz grado 1 grano largo', 'arroz-grado-1-grano-largo-003967', 'abarrotes', 2226, 1590, 0, 'unidad', true, true, NULL, NULL, 'excel', 120),
  ('7802615006551', '7802615006551', 'Arroz grado 1 largo ancho', 'arroz grado 1 largo ancho', 'arroz-grado-1-largo-ancho-006551', 'abarrotes', 2646, 1890, 0, 'unidad', true, true, NULL, NULL, 'excel', 121),
  ('7804695410016', '7804695410016', 'Arroz grado 2 largo delgado', 'arroz grado 2 largo delgado', 'arroz-grado-2-largo-delgado-410016', 'abarrotes', 1330, 950, 0, 'unidad', true, true, NULL, NULL, 'excel', 122),
  ('BV-MAIN-SALSA-DE-TOMATE-POMAROLA-SAN-REMO', NULL, 'Salsa de tomate Pomarola San Remo', 'salsa de tomate pomarola san remo', 'salsa-de-tomate-pomarola-san-remo-anremo', 'abarrotes', 0, 0, 0, 'unidad', true, true, 'Falta precio y formato. | FALTA PRECIO: editar desde backend antes de vender.', NULL, 'manual', 130),
  ('BV-MAIN-COCA-COLA-LATA-350-ML', NULL, 'Coca-Cola lata 350 ml', 'coca-cola lata 350 ml', 'coca-cola-lata-350-ml-a350ml', 'bebidas', 0, 0, 0, 'unidad', true, true, 'Falta precio y confirmar formato disponible. | FALTA PRECIO: editar desde backend antes de vender.', NULL, 'manual', 140),
  ('BV-MAIN-COCA-COLA-500-ML', NULL, 'Coca-Cola 500 ml', 'coca-cola 500 ml', 'coca-cola-500-ml-a500ml', 'bebidas', 0, 0, 0, 'unidad', true, true, 'Falta precio y confirmar formato disponible. | FALTA PRECIO: editar desde backend antes de vender.', NULL, 'manual', 141),
  ('BV-MAIN-COCA-COLA-1-5-L', NULL, 'Coca-Cola 1.5 L', 'coca-cola 1.5 l', 'coca-cola-1-5-l-ola15l', 'bebidas', 0, 0, 0, 'unidad', true, true, 'Falta precio y confirmar formato disponible. | FALTA PRECIO: editar desde backend antes de vender.', NULL, 'manual', 142),
  ('BV-MAIN-COCA-COLA-2-L', NULL, 'Coca-Cola 2 L', 'coca-cola 2 l', 'coca-cola-2-l-cola2l', 'bebidas', 0, 0, 0, 'unidad', true, true, 'Falta precio y confirmar formato disponible. | FALTA PRECIO: editar desde backend antes de vender.', NULL, 'manual', 143),
  ('BV-MAIN-COCA-COLA-3-L', NULL, 'Coca-Cola 3 L', 'coca-cola 3 l', 'coca-cola-3-l-cola3l', 'bebidas', 0, 0, 0, 'unidad', true, true, 'Falta precio y confirmar formato disponible. | FALTA PRECIO: editar desde backend antes de vender.', NULL, 'manual', 144),
  ('BV-MAIN-MONSTER-ENERGY', NULL, 'Monster Energy', 'monster energy', 'monster-energy-energy', 'bebidas', 0, 0, 0, 'unidad', true, true, 'Falta precio y formato/sabor. | FALTA PRECIO: editar desde backend antes de vender.', NULL, 'manual', 150),
  ('BV-MAIN-SCORE-ENERGY-DRINK', NULL, 'Score Energy Drink', 'score energy drink', 'score-energy-drink-ydrink', 'bebidas', 0, 0, 0, 'unidad', true, true, 'Falta precio y formato/sabor. | FALTA PRECIO: editar desde backend antes de vender.', NULL, 'manual', 151),
  ('780292077542', '780292077542', 'Leche entera larga vida 1 L', 'leche entera larga vida 1 l', 'leche-entera-larga-vida-1-l-077542', 'lacteos-embutidos', 1610, 1150, 0, 'unidad', true, true, NULL, NULL, 'excel', 170),
  ('BV-MAIN-CABALLA-EN-CONSERVA', NULL, 'Caballa en conserva', 'caballa en conserva', 'caballa-en-conserva-nserva', 'abarrotes', 0, 0, 0, 'unidad', true, true, 'Falta precio, marca y formato. | FALTA PRECIO: editar desde backend antes de vender.', NULL, 'manual', 180),
  ('BV-KENT-IKON-MIX-20', NULL, 'Cigarros Kent Ikon Mix 20', 'cigarros kent ikon mix 20', 'cigarros-kent-ikon-mix-20-nmix20', 'cigarros', 7311, 5222, 0, 'unidad', true, true, 'Sin código visible', NULL, 'excel', 190),
  ('BV-KENT-ROSE', NULL, 'Cigarros Kent Rose 20', 'cigarros kent rose 20', 'cigarros-kent-rose-20-ntrose', 'cigarros', 7311, 5222, 0, 'unidad', true, true, 'Sin código visible', NULL, 'excel', 191),
  ('BV-KENT-TRUE', NULL, 'Cigarros Kent True 20', 'cigarros kent true 20', 'cigarros-kent-true-20-nttrue', 'cigarros', 7311, 5222, 0, 'unidad', true, true, 'Sin código visible / texto parcialmente borroso', NULL, 'excel', 192),
  ('BV-LUCKY-STR-BLUE-BOX-20', NULL, 'Cigarros Lucky Strike Blue Box 20', 'cigarros lucky strike blue box 20', 'cigarros-lucky-strike-blue-box-20-ebox20', 'cigarros', 7669, 5478, 0, 'unidad', true, true, 'Sin código visible', NULL, 'excel', 193),
  ('BV-PALL-MALL-CLICK-XL', NULL, 'Cigarros Pall Mall Click XL 20', 'cigarros pall mall click xl 20', 'cigarros-pall-mall-click-xl-20-lickxl', 'cigarros', 6650, 4750, 0, 'unidad', true, true, 'Sin código visible', NULL, 'excel', 194),
  ('BV-MAIN-JUGO-WATTS', NULL, 'Jugo Watts', 'jugo watts', 'jugo-watts-owatts', 'bebidas', 0, 0, 0, 'unidad', true, true, 'Falta precio y formato/sabor. | FALTA PRECIO: editar desde backend antes de vender.', NULL, 'manual', 200),
  ('BV-MAIN-PRESTOBARBA', NULL, 'Prestobarba', 'prestobarba', 'prestobarba-obarba', 'higiene-personal', 0, 0, 0, 'unidad', true, true, 'Falta precio y confirmar marca/modelo. | FALTA PRECIO: editar desde backend antes de vender.', NULL, 'manual', 210),
  ('BV-MAIN-SAL', NULL, 'Sal', 'sal', 'sal-ainsal', 'abarrotes', 0, 0, 0, 'unidad', true, true, 'Falta precio y formato/peso. | FALTA PRECIO: editar desde backend antes de vender.', NULL, 'manual', 220),
  ('7801505231912', '7801505231912', 'Azúcar granulada', 'azucar granulada', 'azucar-granulada-231912', 'abarrotes', 1722, 1230, 0, 'unidad', true, true, NULL, NULL, 'excel', 230),
  ('BV-MAIN-ENDULZANTE', NULL, 'Endulzante', 'endulzante', 'endulzante-lzante', 'abarrotes', 0, 0, 0, 'unidad', true, true, 'Falta precio y formato. | FALTA PRECIO: editar desde backend antes de vender.', NULL, 'manual', 240),
  ('7801875069360', '7801875069360', 'Bolsa de basura 70 x 90 cm', 'bolsa de basura 70 x 90 cm', 'bolsa-de-basura-70-x-90-cm-069360', 'aseo-hogar', 1344, 960, 0, 'unidad', true, true, NULL, NULL, 'excel', 260),
  ('7801875069153', '7801875069153', 'Bolsa de basura 80 x 110 cm', 'bolsa de basura 80 x 110 cm', 'bolsa-de-basura-80-x-110-cm-069153', 'aseo-hogar', 2016, 1440, 0, 'unidad', true, true, NULL, NULL, 'excel', 261),
  ('BV-MAIN-CLORO', NULL, 'Cloro', 'cloro', 'cloro-ncloro', 'aseo-hogar', 0, 0, 0, 'unidad', true, true, 'Falta precio y formato. | FALTA PRECIO: editar desde backend antes de vender.', NULL, 'manual', 270),
  ('BV-MAIN-CLORO-GEL', NULL, 'Cloro gel', 'cloro gel', 'cloro-gel-orogel', 'aseo-hogar', 0, 0, 0, 'unidad', true, true, 'Falta precio y formato. | FALTA PRECIO: editar desde backend antes de vender.', NULL, 'manual', 271),
  ('BV-MAIN-DETERGENTE-OMO', NULL, 'Detergente Omo', 'detergente omo', 'detergente-omo-nteomo', 'aseo-hogar', 0, 0, 0, 'unidad', true, true, 'Falta precio y formato. | FALTA PRECIO: editar desde backend antes de vender.', NULL, 'manual', 280),
  ('BV-MAIN-QUIX-LAVALOZAS', NULL, 'Quix lavalozas', 'quix lavalozas', 'quix-lavalozas-alozas', 'aseo-hogar', 0, 0, 0, 'unidad', true, true, 'Falta precio y formato. | FALTA PRECIO: editar desde backend antes de vender.', NULL, 'manual', 290),
  ('BV-MAIN-CIF-LIMPIADOR', NULL, 'Cif limpiador', 'cif limpiador', 'cif-limpiador-piador', 'aseo-hogar', 0, 0, 0, 'unidad', true, true, 'Falta precio y formato. | FALTA PRECIO: editar desde backend antes de vender.', NULL, 'manual', 300),
  ('BV-MAIN-MATAMOSCAS', NULL, 'Matamoscas', 'matamoscas', 'matamoscas-moscas', 'aseo-hogar', 0, 0, 0, 'unidad', true, true, 'Falta precio y formato. | FALTA PRECIO: editar desde backend antes de vender.', NULL, 'manual', 310),
  ('7802950002119', '7802950002119', 'Nescafé instantáneo', 'nescafe instantaneo', 'nescafe-instantaneo-002119', 'abarrotes', 3724, 2660, 0, 'unidad', true, true, NULL, NULL, 'excel', 330),
  ('BV-MAIN-TE', NULL, 'Té', 'te', 'te-mainte', 'abarrotes', 0, 0, 0, 'unidad', true, true, 'Falta precio, marca y formato. | FALTA PRECIO: editar desde backend antes de vender.', NULL, 'manual', 340),
  ('BV-MAIN-CAFE-EN-SOBRE', NULL, 'Café en sobre', 'cafe en sobre', 'cafe-en-sobre-nsobre', 'abarrotes', 0, 0, 0, 'unidad', true, true, 'Falta precio y formato. | FALTA PRECIO: editar desde backend antes de vender.', NULL, 'manual', 341),
  ('780292000782', '780292000782', 'Leche Colun 200 cc', 'leche colun 200 cc', 'leche-colun-200-cc-000782', 'lacteos-embutidos', 742, 530, 0, 'unidad', true, true, NULL, NULL, 'excel', 350),
  ('7801320000007', '7801320000007', 'Aceite maravilla', 'aceite maravilla', 'aceite-maravilla-000007', 'abarrotes', 3906, 2790, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('779027200058', '779027200058', 'Aceite vegetal', 'aceite vegetal', 'aceite-vegetal-200058', 'abarrotes', 2086, 1490, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7802420011528', '7802420011528', 'Aceituna azapa', 'aceituna azapa', 'aceituna-azapa-011528', 'abarrotes', 3010, 2150, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('780242006195', '780242006195', 'Aceituna sevillana', 'aceituna sevillana', 'aceituna-sevillana-006195', 'abarrotes', 3038, 2170, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('780264000142', '780264000142', 'Ají crema chileno', 'aji crema chileno', 'aji-crema-chileno-000142', 'abarrotes', 840, 600, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7802950005943', '7802950005943', 'Caldo Maggi 12 unidades', 'caldo maggi 12 unidades', 'caldo-maggi-12-unidades-005943', 'abarrotes', 1666, 1190, 0, 'unidad', true, false, 'Nombre repetido o formato abreviado: revisar tamaño/sabor/marca.', NULL, 'excel', 1000),
  ('7802950005974', '7802950005974', 'Caldo Maggi 12 unidades', 'caldo maggi 12 unidades', 'caldo-maggi-12-unidades-005974', 'abarrotes', 1666, 1190, 0, 'unidad', true, false, 'Nombre repetido o formato abreviado: revisar tamaño/sabor/marca.', NULL, 'excel', 1000),
  ('7790580243678', '7790580243678', 'Caramelo menta chocolate', 'caramelo menta chocolate', 'caramelo-menta-chocolate-243678', 'abarrotes', 4046, 2890, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('780540005746', '780540005746', 'Chancaca 1 bloque', 'chancaca 1 bloque', 'chancaca-1-bloque-005746', 'abarrotes', 1638, 1170, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7613034279316', '7613034279316', 'Chocolate Capri 30 g', 'chocolate capri 30 g', 'chocolate-capri-30-g-279316', 'abarrotes', 1008, 720, 0, 'unidad', true, false, 'Nombre repetido o formato abreviado: revisar tamaño/sabor/marca.', NULL, 'excel', 1000),
  ('7613034279750', '7613034279750', 'Chocolate Capri 30 g', 'chocolate capri 30 g', 'chocolate-capri-30-g-279750', 'abarrotes', 1008, 720, 0, 'unidad', true, false, 'Nombre repetido o formato abreviado: revisar tamaño/sabor/marca.', NULL, 'excel', 1000),
  ('7802215121258', '7802215121258', 'Chocolate Rolls', 'chocolate rolls', 'chocolate-rolls-121258', 'abarrotes', 2632, 1880, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7802225428206', '7802225428206', 'Chocolate confitado', 'chocolate confitado', 'chocolate-confitado-428206', 'abarrotes', 8470, 6050, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7802225428361', '7802225428361', 'Chocolate maní', 'chocolate mani', 'chocolate-mani-428361', 'abarrotes', 8470, 6050, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7802225538121', '7802225538121', 'Chocolate tradicional', 'chocolate tradicional', 'chocolate-tradicional-538121', 'abarrotes', 6706, 4790, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7802225426718', '7802225426718', 'Confite saquito chocolate', 'confite saquito chocolate', 'confite-saquito-chocolate-426718', 'abarrotes', 7770, 5550, 0, 'unidad', true, false, 'Media: nombre abreviado', NULL, 'excel', 1000),
  ('780296017255', '780296017255', 'Discos de chocolate', 'discos de chocolate', 'discos-de-chocolate-017255', 'abarrotes', 8946, 6390, 0, 'unidad', true, false, 'Media: nombre/código parcialmente borroso', NULL, 'excel', 1000),
  ('7802575002235', '7802575002235', 'Fideo Carozzi 400 g', 'fideo carozzi 400 g', 'fideo-carozzi-400-g-002235', 'abarrotes', 1050, 750, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7802500001029', '7802500001029', 'Fideo cabello de ángel Lucchetti', 'fideo cabello de angel lucchetti', 'fideo-cabello-de-angel-lucchetti-001029', 'abarrotes', 966, 690, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7613030121046', '7613030121046', 'Fortificante instantáneo', 'fortificante instantaneo', 'fortificante-instantaneo-121046', 'abarrotes', 4662, 3330, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7613287755841', '7613287755841', 'Galleta bañada chocolate', 'galleta banada chocolate', 'galleta-banada-chocolate-755841', 'abarrotes', 8106, 5790, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7805000322502', '7805000322502', 'Ketchup Hellmann’s', 'ketchup hellmann’s', 'ketchup-hellmann-s-322502', 'abarrotes', 3766, 2690, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7803000000659', '7803000000659', 'Levadura seca Lefersa', 'levadura seca lefersa', 'levadura-seca-lefersa-000659', 'abarrotes', 2954, 2110, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7802200132696', '7802200132696', 'Mentitas Florete', 'mentitas florete', 'mentitas-florete-132696', 'abarrotes', 364, 260, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7801916029726', '7801916029726', 'Pasta de pollo La Preferida', 'pasta de pollo la preferida', 'pasta-de-pollo-la-preferida-029726', 'abarrotes', 1162, 830, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('41789001925', '41789001925', 'Pasta instantánea Maruchan', 'pasta instantanea maruchan', 'pasta-instantanea-maruchan-001925', 'abarrotes', 1344, 960, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('780196000718', '780196000718', 'Paté de ternera La Preferida', 'pate de ternera la preferida', 'pate-de-ternera-la-preferida-000718', 'abarrotes', 1568, 1120, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('780197004305', '780197004305', 'Paté de ternera San Jorge', 'pate de ternera san jorge', 'pate-de-ternera-san-jorge-004305', 'abarrotes', 812, 580, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('41789002915', '41789002915', 'Sopa ramen Maruchan', 'sopa ramen maruchan', 'sopa-ramen-maruchan-002915', 'abarrotes', 826, 590, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7801620005160', '7801620005160', 'Bebida Gatorade 1 L', 'bebida gatorade 1 l', 'bebida-gatorade-1-l-005160', 'bebidas', 1778, 1270, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7802575220158', '7802575220158', 'Néctar Sprim pack 3 unidades', 'nectar sprim pack 3 unidades', 'nectar-sprim-pack-3-unidades-220158', 'bebidas', 966, 690, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7802575220783', '7802575220783', 'Néctar Sprim recreo', 'nectar sprim recreo', 'nectar-sprim-recreo-220783', 'bebidas', 966, 690, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7809511721655', '7809511721655', 'Pack hamburguesa', 'pack hamburguesa', 'pack-hamburguesa-721655', 'carnes-congelados', 1190, 850, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('780797500661', '780797500661', 'Frutilla congelada', 'frutilla congelada', 'frutilla-congelada-500661', 'frutas-verduras', 4046, 2890, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('780797500647', '780797500647', 'Mix berries congelado', 'mix berries congelado', 'mix-berries-congelado-500647', 'frutas-verduras', 5306, 3790, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7801300001024', '7801300001024', 'Mix de berries', 'mix de berries', 'mix-de-berries-001024', 'frutas-verduras', 4676, 3340, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7591066711014', '7591066711014', 'Máquina de afeitar Xtreme', 'maquina de afeitar xtreme', 'maquina-de-afeitar-xtreme-711014', 'higiene-personal', 1064, 760, 0, 'unidad', true, false, 'Media: nombre abreviado', NULL, 'excel', 1000),
  ('7622201715236', '7622201715236', 'Chocolate con leche', 'chocolate con leche', 'chocolate-con-leche-715236', 'lacteos-embutidos', 1820, 1300, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7613034276490', '7613034276490', 'Chocolate de leche', 'chocolate de leche', 'chocolate-de-leche-276490', 'lacteos-embutidos', 798, 570, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7613032415679', '7613032415679', 'Crema de leche Nestlé', 'crema de leche nestle', 'crema-de-leche-nestle-415679', 'lacteos-embutidos', 1946, 1390, 0, 'unidad', true, false, 'Nombre repetido o formato abreviado: revisar tamaño/sabor/marca.', NULL, 'excel', 1000),
  ('761303241580', '761303241580', 'Crema de leche Nestlé', 'crema de leche nestle', 'crema-de-leche-nestle-241580', 'lacteos-embutidos', 1246, 890, 0, 'unidad', true, false, 'Media: código/precio parcialmente borroso | Nombre repetido o formato abreviado: revisar tamaño/sabor/marca.', NULL, 'excel', 1000),
  ('7613030120582', '7613030120582', 'Fortificante para leche', 'fortificante para leche', 'fortificante-para-leche-120582', 'lacteos-embutidos', 13090, 9350, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('91678', '91678', 'Jamón pierna', 'jamon pierna', 'jamon-pierna-91678', 'lacteos-embutidos', 11368, 8120, 0, 'unidad', true, false, 'Media: código PLU/peso', NULL, 'excel', 1000),
  ('8445290118288', '8445290118288', 'Leche Buen Día larga vida', 'leche buen dia larga vida', 'leche-buen-dia-larga-vida-118288', 'lacteos-embutidos', 9030, 6450, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('780290006025', '780290006025', 'Leche Soprole 200 cc', 'leche soprole 200 cc', 'leche-soprole-200-cc-006025', 'lacteos-embutidos', 560, 400, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7613030049803', '7613030049803', 'Leche condensada Nestlé', 'leche condensada nestle', 'leche-condensada-nestle-049803', 'lacteos-embutidos', 2170, 1550, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('761328704460', '761328704460', 'Manjar bolsa Nestlé', 'manjar bolsa nestle', 'manjar-bolsa-nestle-704460', 'lacteos-embutidos', 1470, 1050, 0, 'unidad', true, false, 'Nombre repetido o formato abreviado: revisar tamaño/sabor/marca.', NULL, 'excel', 1000),
  ('780295000492', '780295000492', 'Manjar bolsa Nestlé', 'manjar bolsa nestle', 'manjar-bolsa-nestle-000492', 'lacteos-embutidos', 4746, 3390, 0, 'unidad', true, false, 'Nombre repetido o formato abreviado: revisar tamaño/sabor/marca.', NULL, 'excel', 1000),
  ('780295000915', '780295000915', 'Manjar bolsa Nestlé', 'manjar bolsa nestle', 'manjar-bolsa-nestle-000915', 'lacteos-embutidos', 3388, 2420, 0, 'unidad', true, false, 'Nombre repetido o formato abreviado: revisar tamaño/sabor/marca.', NULL, 'excel', 1000),
  ('844529179238', '844529179238', 'Manjar sin lactosa', 'manjar sin lactosa', 'manjar-sin-lactosa-179238', 'lacteos-embutidos', 2730, 1950, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('789300065253', '789300065253', 'Margarina pote Quaker', 'margarina pote quaker', 'margarina-pote-quaker-065253', 'lacteos-embutidos', 2926, 2090, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('780295001047', '780295001047', 'Queso crema Greenfield', 'queso crema greenfield', 'queso-crema-greenfield-001047', 'lacteos-embutidos', 20230, 14450, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('762220197560', '762220197560', 'Queso crema Philadelphia', 'queso crema philadelphia', 'queso-crema-philadelphia-197560', 'lacteos-embutidos', 4326, 3090, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('780290005896', '780290005896', 'Queso para fundir', 'queso para fundir', 'queso-para-fundir-005896', 'lacteos-embutidos', 1946, 1390, 0, 'unidad', true, false, 'Nombre repetido o formato abreviado: revisar tamaño/sabor/marca.', NULL, 'excel', 1000),
  ('7802920005836', '7802920005836', 'Queso para fundir', 'queso para fundir', 'queso-para-fundir-005836', 'lacteos-embutidos', 2352, 1680, 0, 'unidad', true, false, 'Nombre repetido o formato abreviado: revisar tamaño/sabor/marca.', NULL, 'excel', 1000),
  ('7801907008402', '7801907008402', 'Vienesas tradicionales (revisar formato)', 'vienesas tradicionales (revisar formato)', 'vienesas-tradicionales-revisar-formato-008402', 'lacteos-embutidos', 1232, 880, 0, 'unidad', true, false, 'Media: código borroso | Nombre repetido o formato abreviado: revisar tamaño/sabor/marca. | Confirmar marca/formato; no destacado por ahora.', NULL, 'excel', 1000),
  ('780290000220', '780290000220', 'Yoghurt 1+1', 'yoghurt 1+1', 'yoghurt-1-1-000220', 'lacteos-embutidos', 658, 470, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('780290230227', '780290230227', 'Yoghurt batido Soprole', 'yoghurt batido soprole', 'yoghurt-batido-soprole-230227', 'lacteos-embutidos', 350, 250, 0, 'unidad', true, false, 'Nombre repetido o formato abreviado: revisar tamaño/sabor/marca.', NULL, 'excel', 1000),
  ('780290230241', '780290230241', 'Yoghurt batido Soprole', 'yoghurt batido soprole', 'yoghurt-batido-soprole-230241', 'lacteos-embutidos', 350, 250, 0, 'unidad', true, false, 'Nombre repetido o formato abreviado: revisar tamaño/sabor/marca.', NULL, 'excel', 1000),
  ('780290230258', '780290230258', 'Yoghurt batido Soprole', 'yoghurt batido soprole', 'yoghurt-batido-soprole-230258', 'lacteos-embutidos', 350, 250, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('780242001511', '780242001511', 'Chucrut Tentro 360 g', 'chucrut tentro 360 g', 'chucrut-tentro-360-g-001511', 'otros', 910, 650, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7802900105013', '7802900105013', 'Crema espesa larga vida', 'crema espesa larga vida', 'crema-espesa-larga-vida-105013', 'otros', 1484, 1060, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7802575012210', '7802575012210', 'Patrucas Carozzi', 'patrucas carozzi', 'patrucas-carozzi-012210', 'otros', 854, 610, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('2050003512367', '2050003512367', 'Set 2 asaderas vidrio', 'set 2 asaderas vidrio', 'set-2-asaderas-vidrio-512367', 'otros', 6986, 4990, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7802900600006', '7802900600006', 'Margarina Soprole Pan', 'margarina soprole pan', 'margarina-soprole-pan-600006', 'panaderia', 700, 500, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7802200230293', '7802200230293', 'Caluga clásica Suny', 'caluga clasica suny', 'caluga-clasica-suny-230293', 'snacks', 2786, 1990, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7802225310185', '7802225310185', 'Caramelo Alka 400 g', 'caramelo alka 400 g', 'caramelo-alka-400-g-310185', 'snacks', 3430, 2450, 0, 'unidad', true, false, 'Nombre repetido o formato abreviado: revisar tamaño/sabor/marca.', NULL, 'excel', 1000),
  ('7802225310192', '7802225310192', 'Caramelo Alka 400 g', 'caramelo alka 400 g', 'caramelo-alka-400-g-310192', 'snacks', 3430, 2450, 0, 'unidad', true, false, 'Nombre repetido o formato abreviado: revisar tamaño/sabor/marca.', NULL, 'excel', 1000),
  ('780220013476', '780220013476', 'Caramelo Blan Flip', 'caramelo blan flip', 'caramelo-blan-flip-013476', 'snacks', 1358, 970, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('780220002015', '780220002015', 'Caramelo toffee Suny', 'caramelo toffee suny', 'caramelo-toffee-suny-002015', 'snacks', 7630, 5450, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7802225130882', '7802225130882', 'Chicle sabores surtidos', 'chicle sabores surtidos', 'chicle-sabores-surtidos-130882', 'snacks', 19670, 14050, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('780215303401', '780215303401', 'Chokman Costa 33 g', 'chokman costa 33 g', 'chokman-costa-33-g-303401', 'snacks', 224, 160, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7802230082503', '7802230082503', 'Galleta Alteza McKay', 'galleta alteza mckay', 'galleta-alteza-mckay-082503', 'snacks', 1666, 1190, 0, 'unidad', true, false, 'Nombre repetido o formato abreviado: revisar tamaño/sabor/marca.', NULL, 'excel', 1000),
  ('7802230082527', '7802230082527', 'Galleta Alteza McKay', 'galleta alteza mckay', 'galleta-alteza-mckay-082527', 'snacks', 1666, 1190, 0, 'unidad', true, false, 'Nombre repetido o formato abreviado: revisar tamaño/sabor/marca.', NULL, 'excel', 1000),
  ('7802230082534', '7802230082534', 'Galleta Alteza McKay', 'galleta alteza mckay', 'galleta-alteza-mckay-082534', 'snacks', 1666, 1190, 0, 'unidad', true, false, 'Nombre repetido o formato abreviado: revisar tamaño/sabor/marca.', NULL, 'excel', 1000),
  ('7802215512421', '7802215512421', 'Galleta Frac Costa', 'galleta frac costa', 'galleta-frac-costa-512421', 'snacks', 728, 520, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7802215514326', '7802215514326', 'Galleta Obsesión', 'galleta obsesion', 'galleta-obsesion-514326', 'snacks', 1582, 1130, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7802225689014', '7802225689014', 'Galleta cracker', 'galleta cracker', 'galleta-cracker-689014', 'snacks', 658, 470, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7802225614498', '7802225614498', 'Galleta mini Arcor', 'galleta mini arcor', 'galleta-mini-arcor-614498', 'snacks', 294, 210, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('780221550466', '780221550466', 'Galleta oblea Nik', 'galleta oblea nik', 'galleta-oblea-nik-550466', 'snacks', 700, 500, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7622201717629', '7622201717629', 'Galleta salada Oreo', 'galleta salada oreo', 'galleta-salada-oreo-717629', 'snacks', 2226, 1590, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7802225412131', '7802225412131', 'Gomita Califrut', 'gomita califrut', 'gomita-califrut-412131', 'snacks', 3752, 2680, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7906220802761', '7906220802761', 'Gomita tubo Twister', 'gomita tubo twister', 'gomita-tubo-twister-802761', 'snacks', 1386, 990, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7896591453274', '7896591453274', 'Gomitas Fini 90 g', 'gomitas fini 90 g', 'gomitas-fini-90-g-453274', 'snacks', 1232, 880, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('8410525127465', '8410525127465', 'Gomitas Roller Fini', 'gomitas roller fini', 'gomitas-roller-fini-127465', 'snacks', 658, 470, 0, 'unidad', true, false, 'Nombre repetido o formato abreviado: revisar tamaño/sabor/marca.', NULL, 'excel', 1000),
  ('841052519039', '841052519039', 'Gomitas Roller Fini', 'gomitas roller fini', 'gomitas-roller-fini-519039', 'snacks', 658, 470, 0, 'unidad', true, false, 'Nombre repetido o formato abreviado: revisar tamaño/sabor/marca.', NULL, 'excel', 1000),
  ('7896451921345', '7896451921345', 'Gomitas aro ácidas', 'gomitas aro acidas', 'gomitas-aro-acidas-921345', 'snacks', 840, 600, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7896591453106', '7896591453106', 'Gomitas regaliz Fini', 'gomitas regaliz fini', 'gomitas-regaliz-fini-453106', 'snacks', 1386, 990, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7896451921321', '7896451921321', 'Gomitas tajada sabor', 'gomitas tajada sabor', 'gomitas-tajada-sabor-921321', 'snacks', 840, 600, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7802420170522', '7802420170522', 'Maní salado Marco Polo', 'mani salado marco polo', 'mani-salado-marco-polo-170522', 'snacks', 7546, 5390, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7807975009754', '7807975009754', 'Maní tipo japonés', 'mani tipo japones', 'mani-tipo-japones-009754', 'snacks', 2086, 1490, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('54300090018', '54300090018', 'Marshmallows Rocky Mountain', 'marshmallows rocky mountain', 'marshmallows-rocky-mountain-090018', 'snacks', 3052, 2180, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7702011305510', '7702011305510', 'Masticable Max Fruit', 'masticable max fruit', 'masticable-max-fruit-305510', 'snacks', 2394, 1710, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7790580178208', '7790580178208', 'Masticable fruta surtida', 'masticable fruta surtida', 'masticable-fruta-surtida-178208', 'snacks', 5922, 4230, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000),
  ('7801930025674', '7801930025674', 'Mini snack Ramitas del Sur', 'mini snack ramitas del sur', 'mini-snack-ramitas-del-sur-025674', 'snacks', 1484, 1060, 0, 'unidad', true, false, 'Nombre repetido o formato abreviado: revisar tamaño/sabor/marca.', NULL, 'excel', 1000),
  ('7801930025711', '7801930025711', 'Mini snack Ramitas del Sur', 'mini snack ramitas del sur', 'mini-snack-ramitas-del-sur-025711', 'snacks', 1484, 1060, 0, 'unidad', true, false, 'Nombre repetido o formato abreviado: revisar tamaño/sabor/marca.', NULL, 'excel', 1000),
  ('7613030612346', '7613030612346', 'Super 8 oblea', 'super 8 oblea', 'super-8-oblea-612346', 'snacks', 8540, 6100, 0, 'unidad', true, false, NULL, NULL, 'excel', 1000)
)
insert into public.products (
  sku, ean, name, name_normalized, slug, description, category_id,
  price, cost, stock, unit, active, featured, needs_review,
  image_url, image_source, position
)
select
  i.sku,
  i.ean,
  i.name,
  i.name_normalized,
  i.slug,
  null::text as description,
  c.id as category_id,
  i.price,
  i.cost,
  i.stock,
  i.unit,
  i.active,
  i.featured,
  i.needs_review,
  i.image_url,
  i.image_source,
  i.position
from incoming i
left join public.categories c on c.slug = i.category_slug
on conflict (sku) do update set
  ean = excluded.ean,
  name = excluded.name,
  name_normalized = excluded.name_normalized,
  slug = excluded.slug,
  description = excluded.description,
  category_id = excluded.category_id,
  price = excluded.price,
  cost = excluded.cost,
  stock = excluded.stock,
  unit = excluded.unit,
  active = excluded.active,
  featured = excluded.featured,
  needs_review = excluded.needs_review,
  image_url = coalesce(public.products.image_url, excluded.image_url),
  image_source = excluded.image_source,
  position = excluded.position,
  updated_at = now();

-- Resumen rápido para validar
select
  count(*) filter (where active = true) as productos_visibles,
  count(*) filter (where featured = true and active = true) as destacados_portada,
  count(*) filter (where price = 0 and active = true) as visibles_sin_precio,
  count(*) filter (where needs_review is not null and active = true) as visibles_para_revision
from public.products;

commit;
