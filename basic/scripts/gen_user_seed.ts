import { faker } from '@faker-js/faker';
import { writeCsv } from './csv_writer.js';

async function main() {
  const totalRows = 30_000;

  function* rows() {
    for (let i = 0; i < totalRows; i++) {
      yield {
        username: faker.internet.username() + faker.number.int({ min: 1, max: 1000 }).toString(),
        status: faker.helpers.arrayElement(['ONLINE', 'OFFLINE']),
        email: faker.internet.email({
          lastName: faker.number.int({ min: 1, max: 1000000 }).toString(),
        }),
      };
    }
  }

  await writeCsv('./basic/seeds/users.csv', rows());
}

main()
  .catch(console.error)
  .finally(() => process.exit(0));
