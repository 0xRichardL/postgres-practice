import * as csv from 'csv';
import * as fs from 'fs';
import { Readable } from 'stream';

export async function writeCsv(path: string, rows: Iterable<object>): Promise<void> {
  await new Promise((resolve, reject) => {
    let counter = 0;
    const writer = csv.stringify({
      header: true,
      quote: true,
    });
    writer.pipe(fs.createWriteStream(path));
    const input = Readable.from(rows);
    input.on('data', () => {
      counter++;
    });
    input
      .pipe(writer)
      .on('finish', () => {
        console.log(`Successfully generated ${counter} rows`);
        resolve(undefined);
      })
      .on('error', (err) => {
        reject(err);
      });
  });
}
