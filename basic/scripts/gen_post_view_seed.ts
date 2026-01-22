import { faker } from '@faker-js/faker';
import { writeCsv } from './csv_writer.js';

async function main() {
  const totalRows = 10_000_000;

  const check = new Set<string>();

  function* rows() {
    for (let i = 0; i < totalRows; i++) {
      let post_id = faker.number.int({ min: 1, max: 500_000 });
      let user_id = faker.number.int({ min: 1, max: 1_000 });
      let viewed_at = faker.date.past().toISOString();
      while (true) {
        post_id = faker.number.int({ min: 1, max: 500_000 });
        user_id = faker.number.int({ min: 1, max: 1_000 });
        if (!check.has(`${post_id}-${user_id}`)) {
          check.add(`${post_id}-${user_id}`);
          break;
        }
      }
      yield {
        post_id,
        user_id,
        viewed_at,
      };
    }
  }

  await writeCsv('./basic/seeds/post_views.csv', rows());
}

main().catch(console.error);
