public class RandomDataGenerator {

    public Integer GetRandomNumber(Integer multiplier) {
        return Integer.valueof(Math.random() * multiplier);
    }

    public String GenerateRandomFullName() {
        Integer randomInitialIndex = GetRandomNumber(Names.Initials.size() - 1);
        String randomFullName = GenerateRandomFirstName() + ' ' + Names.Initials[randomInitialIndex] + '. ' + GenerateRandomLastName();
        return randomFullName;
    }

    public String GenerateRandomFirstName() {
        Integer randomFirstNameIndex = GetRandomNumber(Names.FirstNames.size() - 1);
        return Names.FirstNames[randomFirstNameIndex];
    }
    
    public String GenerateRandomLastName() {
        Integer randomLastNameIndex = GetRandomNumber(Names.LastNames.size() - 1);
        return Names.LastNames[randomLastNameIndex];
    }
    
    public String GenerateRandomPhone() {
        String randomAreaCode = String.valueOf(GetRandomNumber(1000));
        String randomMiddleBit = String.valueOf(GetRandomNumber(1000));
        String randomLastBit = String.valueOf(GetRandomNumber(100000));
        return '(' + randomAreaCode + ') ' + randomMiddleBit + ' ' + randomLastBit;
    }

    public Boolean GenerateRandomBool() {
        Integer oneOrZero = GetRandomNumber(2);
        return oneOrZero == 1;
    }
    
    public String GenerateRandomCompany() {
        Integer randomSuffixIndex = GetRandomNumber(Names.CompanySuffixes.size() - 1);
        String randomSuffix = Names.CompanySuffixes[randomSuffixIndex];
        return GenerateRandomLastName() + randomSuffix;
    }
    
    public String GenerateRandomString(Integer stringLength) {
        String randomString = '';

        for (Integer i = 0; i < stringLength; i++) {
            Integer randomInitialIndex = GetRandomNumber(Names.Initials.size() - 1);
            randomString += Names.Initials[randomInitialIndex];
        }

        return randomString;
    }
    
    public String GenerateRandomStringOfMaxLength(Integer maxStringLength) {
        Integer stringLength = GetRandomNumber(maxStringLength);
        return GenerateRandomString(stringLength);
    }
}