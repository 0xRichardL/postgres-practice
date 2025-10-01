import * as csv from 'csv';
import * as fs from 'fs';
import { faker } from '@faker-js/faker';

function main() {
  const file = new fs.WriteStream('./seeds/posts_500k.csv');
  file.write('title,metadata\n');
  csv
    .generate({ length: 500_000 })
    .pipe(
      csv.transform((_) => {
        return [
          faker.lorem.sentence(),
          JSON.stringify({
            read_time: faker.number.int({ min: 1, max: 1_000_000 }),
            featured: faker.datatype.boolean(),
          }),
        ];
      })
    )
    .pipe(csv.stringify({ quote: true }))
    .pipe(file);
}

main();
