DROP INDEX УЧАСТНИК_ИНДЕКС;


CREATE INDEX УЧАСТНИК_ИНДЕКС ON УЧАСТНИК Using Hash (ID_КОМАНДА);
CREATE INDEX УЧАСТНИК_ИНДЕКС ON УЧАСТНИК Using BTREE (ID_КОМАНДА);
