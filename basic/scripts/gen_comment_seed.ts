import { faker } from '@faker-js/faker';
import { writeCsv } from '../../shared/csv_writer.js';

async function main() {
  const totalRows = 5_000_000;

  function* rows() {
    for (let i = 0; i < totalRows; i++) {
      yield {
        post_id: faker.number.int({ min: 1, max: 500_000 }),
        parent_id: faker.datatype.boolean() ? faker.number.int({ min: 1, max: 500_000 }) : null,
        content: faker.lorem.sentences(1),
      };
    }
  }

  await writeCsv('./basic/seeds/comments.csv', rows());
}

main().catch(console.error);
