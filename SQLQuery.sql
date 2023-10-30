WITH rs AS (
  SELECT 
    s.id AS sub_id,
    s.name AS sub_name,
    c.subdivision_id,
    0 AS sub_level,
    (SELECT COUNT(*) FROM dbo.collaborators WHERE subdivision_id = c.subdivision_id) AS colls_count
  FROM 
    dbo.subdivisions s
    JOIN dbo.collaborators c ON s.id = c.subdivision_id
  WHERE 
    c.name = 'Сотрудник 1' AND c.id = 710253
  UNION ALL
  SELECT
    s2.id,
    s2.name,
    s2.parent_id,
    rs.sub_level + 1,
    rs.colls_count
  FROM
    dbo.subdivisions s2
    INNER JOIN rs ON s2.parent_id = rs.sub_id
    WHERE s2.id NOT IN (100055, 100059)
)

SELECT
  c.id,
  c.name,
  rs.sub_name,
  rs.sub_id,
  rs.sub_level,
  COUNT(rs.sub_id) OVER (PARTITION BY rs.sub_name) AS colls_count
FROM
  dbo.collaborators c
  JOIN rs ON c.subdivision_id = rs.sub_id
WHERE
  c.age < 40 AND LEN(c.name) > 11
ORDER BY
  rs.sub_level;