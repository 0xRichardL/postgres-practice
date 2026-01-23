import { faker } from '@faker-js/faker';
import { writeCsv } from '../../shared/csv_writer.js';

async function main() {
  const totalRows = 30_000;

  function* rows() {
    for (let i = 0; i < totalRows; i++) {
      yield {
        username: faker.internet.username() + faker.string.uuid(),
        status: faker.helpers.arrayElement(['ONLINE', 'OFFLINE']),
        email: faker.internet.email({
          lastName: faker.string.uuid(),
        }),
      };
    }
  }

  await writeCsv('./basic/seeds/users.csv', rows());
}

main().catch(console.error);
