CREATE TABLE task_2_data_ex (
    year INT,
    month INT,
    produced_material VARCHAR(50),
    produced_material_production_type INT,
    produced_material_release_type VARCHAR(10),
    produced_material_quantity NUMERIC(15, 2),
    component_material VARCHAR(50),
    component_material_production_type INT,
    component_material_release_type VARCHAR(10),
    component_material_quantity NUMERIC(15, 2),
    plant_id VARCHAR(50)
);

WITH RECURSIVE tree_of_materials AS (
    SELECT 
        plant_id AS plant,
        produced_material AS fin_material_id,
        produced_material_release_type AS fin_material_release_type,
        produced_material_production_type AS fin_material_production_type,
        produced_material_quantity AS fin_production_quantity,

        produced_material AS prod_material_id,
        produced_material_release_type AS prod_material_release_type,
        produced_material_production_type AS prod_material_production_type,
        produced_material_quantity AS prod_material_production_quantity,
        
        component_material AS component_id,
        component_material_release_type,
        component_material_production_type,
        component_material_quantity AS component_consumption_quantity,
        year
    FROM task_2_data_ex
    WHERE produced_material_release_type = 'FIN'
    
    UNION ALL
    
    SELECT
        child.plant,
        child.fin_material_id,
        child.fin_material_release_type,
        child.fin_material_production_type,
        child.fin_production_quantity,
        
        parent.produced_material AS prod_material_id,
        parent.produced_material_release_type AS prod_material_release_type,
        parent.produced_material_production_type AS prod_material_production_type,
        parent.produced_material_quantity AS prod_material_production_quantity,
        
        parent.component_material AS component_id,
        parent.component_material_release_type,
        parent.component_material_production_type,
        parent.component_material_quantity AS component_consumption_quantity,
        child.year
    FROM task_2_data_ex AS parent
    INNER JOIN tree_of_materials AS child ON 
        parent.produced_material = child.component_id
        AND parent.plant_id = child.plant
        AND parent.year = child.year
    WHERE child.component_material_release_type = 'PROD'
)

SELECT 
    plant, 
    fin_material_id, 
    fin_material_release_type, 
    fin_material_production_type, 
    fin_production_quantity,
    prod_material_id, 
    prod_material_release_type, 
    prod_material_production_type,
    prod_material_production_quantity,
    component_id, 
    component_material_release_type, 
    component_material_production_type, 
    component_consumption_quantity,
    year
FROM tree_of_materials
WHERE component_material_release_type IN ('ADD', 'RM')
ORDER BY year;

)