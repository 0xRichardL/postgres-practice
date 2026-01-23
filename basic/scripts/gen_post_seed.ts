import { faker } from '@faker-js/faker';
import { writeCsv } from '../../shared/csv_writer.js';

async function main() {
  const totalRows = 1_000_000;

  function* rows() {
    for (let i = 0; i < totalRows; i++) {
      yield {
        title: faker.lorem.sentence(),
        metadata: JSON.stringify({
          read_time: faker.number.int({ min: 1, max: 1_000_000 }),
          featured: faker.datatype.boolean(),
        }),
      };
    }
  }

  await writeCsv('./basic/seeds/posts.csv', rows());
}

main().catch(console.error);
