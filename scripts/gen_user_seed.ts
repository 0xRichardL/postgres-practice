import { faker } from '@faker-js/faker';
import { writeCsv } from './csv_writer.js';

async function main() {
  const totalRows = 1_000;

  const rows = Array.from({ length: totalRows }, () => ({
    username: faker.internet.username(),
    status: faker.helpers.arrayElement(['ONLINE', 'OFFLINE']),
    email: faker.internet.email(),
  }));

  await writeCsv('./seeds/users.csv', rows);
}

main()
  .catch(console.error)
  .finally(() => process.exit(0));
