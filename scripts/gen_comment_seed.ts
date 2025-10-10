import { faker } from '@faker-js/faker';
import { writeCsv } from './csv_writer.js';

async function main() {
  const totalRows = 1_000_000;

  const rows = Array.from({ length: totalRows }, () => ({
    post_id: faker.number.int({ min: 1, max: 500_000 }),
    parent_id: faker.datatype.boolean() ? faker.number.int({ min: 1, max: 500_000 }) : null,
    content: faker.lorem.sentences(1),
  }));

  await writeCsv('./seeds/comments.csv', rows);
}

main()
  .catch(console.error)
  .finally(() => process.exit(0));
