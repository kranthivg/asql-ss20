-- Tupper's self-referential formula
--
-- Plot points x ∊ [0,106), y ∊ [k, k+17) for which
-- ½ < ⌊mod(⌊y/17⌋ × 2^(-17 × ⌊x⌋ - mod(⌊y⌋, 17), 2)⌋
-- holds.
--
-- The plotted image contains a representation of the formula itself:
--
--          █                   █                █ ██ █     █                █  █ █     █    █ ██ █      █   █
--          █                   █ █      █       █  █ █     █                █  █ █     █    █  █ █      █   █
--  ██      █                  █  █      █    ██ █  █ █ █ █ █ ██ ████  ███ ███ █  █ █ █ █    █  █  █      █  █
--   █      █                  █  █  █ █ █       █ █  █  █  █    █ █ █ █ █ █ █ █  █ █ █ █    █ █   █      █  █
--   █      █                  █  █  █ █ █       █ █  █ █ █ █    █ █ █ ███ ███ █  █  █  █    █ █   █      █  █
--   █      █               █ █   █   █  █  ██        █     █                  █  █ █   █  █       █   ██  █ █
--  ███   █ █               █ █   █  █   █ █  █       █     █                   █ █     █  █      █   █  █ █ █
--       █  █ ██ █   ██   ███ █   █      █   █        ███ ███                   █ ███ ███ █       █     █  █ █
--  ███ █   █ █ █ █ █  █ █  █ █   █ ████ █  █                                                          █   █ █
--       █  █ █ █ █ █  █ █  █ █   █      █ █                                                          █    █ █
--  ██    █ █ █ █ █  ██   ███ █   █ █ ██ █ ████                                                       ████ █ █
--    █     █                 █   █ █  █ █                                                          █      █ █
--   █      █                  █  █ █  █ █                                                          █     █  █
--  █       █                  █  █ █ █  █                                                         █      █  █
--  ███     █                  █  █ █ █  █                                                                █  █
--          █                   █ █      █                                                               █   █
--          ███                 █ ███  ███                                                               █ ███
--
--
-- Can encode *any* 106x17 pixel image in terms of a single value of type numeric
-- (see pixel image editor at http://tuppers-formula.tk): the following encodes the
-- text "Advanced SQL":
--
-- \set k 52286934557658048028425956698007592392599530361873363333609880711749360515697214536719655759234958981559142573143695142261512175715575262178445160479745224050413186652132299326608682173356922986884858803658784114284120559745186144099152093031123509671116955442905501004550625844483047202158923745405732677551008895706387756563881115671352441965257523184483317832915333353792671679709434918092340808285147480120213896185154950991291329376438314822230636406240307557327442470102492396220365764965812928512

\set k 960939379918958884971672962127852754715004339660129306651505519271702802395266424689642842174350718121267153782770623355993237280874144307891325963941337723487857735749823926629715517173716995165232890538221612403238855866184013235585136048828693337902491454229288667081096184496091705183454067827731551705405381627380967602565625016981482083418783163849115590225610003652351370343874461848378737238198224849863465033159410054974700593138339226497249461751545728366702369745461014655997933798537483143786841806593422227898388722980000748404719

WITH
tupper(x, y, pixel) AS (
  SELECT x, y - :k AS y,
         --   ½ < ⌊mod(⌊y/17⌋ × 2^(-17 × ⌊x⌋ - mod(⌊y⌋, 17), 2)⌋  (NB: replaced ⋯ × 2⁻ˣ by ⋯ / 2ˣ)
         0.5 < floor(mod(floor(y / 17.0) / 2^(-(-17 * floor(x) - mod(floor(y), 17))) :: numeric, 2)) AS pixel
  FROM   generate_series(0 , 105)   AS x,  -- x ∊ [0,106)
         generate_series(:k, :k+16) AS y   -- y ∊ [k,k+17)
)
-- Plot pixels
SELECT string_agg(CASE WHEN t.pixel THEN '█' ELSE ' ' END, NULL ORDER BY t.x DESC) AS "Tupper's Formula"
FROM   tupper AS t
GROUP BY t.y
ORDER BY t.y;
