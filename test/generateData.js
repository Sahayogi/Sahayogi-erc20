"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
var ethers_1 = require("ethers");
var bignumber_js_1 = require("bignumber.js");
var path_1 = __importDefault(require("path"));
var fs_1 = __importDefault(require("fs"));
var csv_parser_1 = __importDefault(require("csv-parser"));
var filePath = path_1.default.join(__dirname, 'holders.csv');
var writeFilePath = path_1.default.join(__dirname, 'details.json');
var allUsers = [];
bignumber_js_1.BigNumber.config({
    EXPONENTIAL_AT: 1e9,
    ROUNDING_MODE: bignumber_js_1.BigNumber.ROUND_DOWN,
});
fs_1.default.createReadStream(filePath)
    .pipe((0, csv_parser_1.default)())
    .on('data', function (row) {
    return __awaiter(this, void 0, void 0, function () {
        var balance, user_amount, big_nmber;
        return __generator(this, function (_a) {
            balance = new bignumber_js_1.BigNumber(row.Balance);
            user_amount = balance
                .times(Math.pow(10, 9))
                .integerValue()
                .toString();
            big_nmber = ethers_1.BigNumber.from(user_amount).mul(Math.pow(10, 9));
            console.log(big_nmber.toString());
            allUsers.push({
                account: row.HolderAddress,
                amount: big_nmber.toString(),
            });
            return [2 /*return*/];
        });
    });
})
    .on('end', function () { return __awaiter(void 0, void 0, void 0, function () {
    var jsonAllUser;
    return __generator(this, function (_a) {
        switch (_a.label) {
            case 0: return [4 /*yield*/, JSON.stringify(allUsers)];
            case 1:
                jsonAllUser = _a.sent();
                return [4 /*yield*/, fs_1.default.writeFile(writeFilePath, jsonAllUser, function (err) {
                        if (err) {
                            console.log('Error writing file', err);
                        }
                        else {
                            console.log('Successfully wrote file');
                        }
                    })];
            case 2:
                _a.sent();
                return [2 /*return*/];
        }
    });
}); });
