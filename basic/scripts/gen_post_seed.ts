import { faker } from '@faker-js/faker';
import { writeCsv } from './csv_writer.js';

async function main() {
  const totalRows = 500_000;

  const rows = Array.from({ length: totalRows }, () => ({
    title: faker.lorem.sentence(),
    metadata: JSON.stringify({
      read_time: faker.number.int({ min: 1, max: 1_000_000 }),
      featured: faker.datatype.boolean(),
    }),
  }));

  await writeCsv('./basic/seeds/posts.csv', rows);
}

main()
  .catch(console.error)
  .finally(() => process.exit(0));
